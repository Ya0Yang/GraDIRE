%%  calculate3Dprojection_interp %%

%%calculates 2D projection from 3D object using linear interpolation of
%%central slice in Fourier space
%%inputs:
%%  modelK - 3D Fourier space of object to compute projection of
%%  phi,theta,psi - Euler angles of desired projection

%%outputs:
%%  projection - result

%% Author: Alan (AJ) Pryor, Jr.
%% Jianwei (John) Miao Coherent Imaging Group
%% University of California, Los Angeles
%% Copyright (c) 2015. All Rights Reserved.



function [proj_X,proj_Y,proj_Z] = calculate3Dprojection_splinterp_set(modelX,modelY,modelZ, phi,theta,psi, custom_euler_rot_vecs)

%get dimensions and centers
[dimx, dimy, dimz] = size(modelX);

ncy = round((dimy+1)/2); 
ncx = round((dimx+1)/2); 
ncz = round((dimz+1)/2);

[Y, X, Z] = meshgrid((1:dimy) - ncy, (1:dimx) - ncx, 0);

%calculate rotation matrix
if nargin>6
    R = (MatrixQuaternionRot(custom_euler_rot_vecs{1}, phi) * MatrixQuaternionRot(custom_euler_rot_vecs{2}, theta) * MatrixQuaternionRot(custom_euler_rot_vecs{3}, psi))';
else
    R = [ cosd(psi)*cosd(theta)*cosd(phi)-sind(psi)*sind(phi) ,cosd(psi)*cosd(theta)*sind(phi)+sind(psi)*cosd(phi)   ,    -cosd(psi)*sind(theta);
         -sind(psi)*cosd(theta)*cosd(phi)-cosd(psi)*sind(phi), -sind(psi)*cosd(theta)*sind(phi)+cosd(psi)*cosd(phi) ,   sind(psi)*sind(theta)  ;
          sind(theta)*cosd(phi)                               , sind(theta)*sind(phi)                                ,              cosd(theta)];

end
%[ky kx kz ] = meshgrid((1:dimy) - ncy, (1:dimx) - ncx, (1:dimz) - ncz);

%rotate coordinates
rotkCoords = R'*[X(:)';Y(:)';Z(:)'];
rotKx = rotkCoords(1,:);
rotKy = rotkCoords(2,:);
rotKz = rotkCoords(3,:);

%reshape for interpolation
rotKx = reshape(rotKx,size(X));
rotKy = reshape(rotKy,size(Y));
rotKz = reshape(rotKz,size(Z));

%calculate points on central slice
% pjK = interp3(ky,kx,kz,modelK,rotKy,rotKx,rotKz,'linear');
%pjK = interp3(ky,kx,kz,modelK,rotKy,rotKx,rotKz,'cubic');
pjK = splinterp3(modelX,rotKy+ncy,rotKx+ncx,rotKz+ncz); pjK(isnan(pjK))=0;
proj_X = real(my_ifft(pjK(:,:)));

pjK = splinterp3(modelY,rotKy+ncy,rotKx+ncx,rotKz+ncz); pjK(isnan(pjK))=0;
proj_Y = real(my_ifft(pjK(:,:)));

pjK = splinterp3(modelZ,rotKy+ncy,rotKx+ncx,rotKz+ncz); pjK(isnan(pjK))=0;
proj_Z = real(my_ifft(pjK(:,:)));

end