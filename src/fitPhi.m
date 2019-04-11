function [bestPhi, R_values] = fitPhi(reference_diff_pat,modelK)
modelK = my_fft(modelK); %input model as real space, then let this convert to K
theta = 0;
psi = 0;
nonzeroIndices = reference_diff_pat~=0;
% normTerm = sum(abs(reference_diff_pat(nonzeroIndices)));
bestR = 1e30;

count = 1;
vector_of_phi_values_to_search = 0 :  .25 : 90;
R_values = zeros(1,numel(vector_of_phi_values_to_search));
for phi = vector_of_phi_values_to_search
    phi;
    [~,calculatedPattern] = calculate3Dprojection_interp(modelK,phi,theta,psi);
    calculatedPattern = abs(calculatedPattern);
    calculatedPattern = calculatedPattern .* mean(reference_diff_pat(nonzeroIndices)) ./ mean(calculatedPattern(nonzeroIndices));
    R = sum(abs(reference_diff_pat(nonzeroIndices) - calculatedPattern(nonzeroIndices))) ./ sum(abs(reference_diff_pat(nonzeroIndices)));
    R_values(count )   = R;
    count = count + 1;
    if R < bestR;
        bestR = R;
        bestPhi = phi;
    end
    
end

end

function kout = my_fft(img)
kout = fftshift(fftn((ifftshift(img))));
end

function realout = my_ifft(k)
realout =fftshift((ifftn(ifftshift(k))));
end

%%  calculate3Dprojection_interp %%

%%calculates 2D projection from 3D object quickly using cubic interpolation
%%inputs:
%%  modelK - 3D Fourier space of object to compute projection of
%%  phi,theta,psi - Euler angles of desired projection

%%outputs:
%%  projection - result

%% Author: AJ Pryor
%% Jianwei (John) Miao Coherent Imaging Group
%% University of California, Los Angeles
%% Copyright (c) 2015. All Rights Reserved.



function [projection, pjK] = calculate3Dprojection_interp(modelK,phi,theta,psi)
%%only works for even images in current form%%
%%%%

[dimx dimy dimz] = size(modelK);
ncy = round((dimy+1)/2); ny2 = ncy-1;
ncx = round((dimx+1)/2); nx2 = ncx-1;
ncz = round((dimz+1)/2); nz2 = ncz-1;

[Y X Z] = meshgrid(-ny2:ny2-1,-nx2:nx2-1,0);
% [Y X Z] = meshgrid(-ny2:ny2-1,-nx2:nx2-1,-nz2:nz2-1);




% R = [-sind(psi)*cosd(theta)*sind(phi)+cosd(psi)*cosd(phi), -sind(psi)*cosd(theta)*cosd(phi)-cosd(psi)*sind(phi), sind(psi)*sind(theta);
%   cosd(psi)*cosd(theta)*sind(phi)+sind(psi)*cosd(phi) , cosd(psi)*cosd(theta)*cosd(phi)-sind(psi)*sind(phi) ,-cosd(psi)*sind(theta);
% sind(theta)*sind(phi), sind(theta)*cosd(phi),cosd(theta)];


R = [ cosd(psi)*cosd(theta)*cosd(phi)-sind(psi)*sind(phi) ,cosd(psi)*cosd(theta)*sind(phi)+sind(psi)*cosd(phi)   ,    -cosd(psi)*sind(theta);
      -sind(psi)*cosd(theta)*cosd(phi)-cosd(psi)*sind(phi), -sind(psi)*cosd(theta)*sind(phi)+cosd(psi)*cosd(phi) ,   sind(psi)*sind(theta)  ;
      sind(theta)*cosd(phi)                               , sind(theta)*sind(phi)                                ,              cosd(theta)];

  
[ky kx kz ] = meshgrid(-ny2:ny2-1,-nz2:nz2-1,-nz2:nz2-1);
% kx = single(kx(:))'; ky = single(ky(:))'; %initialize coordinates of unrotate projection slice
% kz = zeros(1,dimx*dimy,'single'); %0 degree rotation is a projection onto the Y-Z plane, so all points have kx=0;
% kz = zeros(size(ky));


rotkCoords = R'*[X(:)';Y(:)';Z(:)'];
% rotCoords = R*[X(:)';Y(:)';Z(:)'];
rotKx = rotkCoords(1,:);
rotKy = rotkCoords(2,:);
rotKz = rotkCoords(3,:);


% rotkCoords = R'*[kx;ky;kz];%rotate coordinates
% rotKx = rotkCoords(1,:);
% rotKy = rotkCoords(2,:);
% rotKz = rotkCoords(3,:);
rotKx = reshape(rotKx,size(X));
rotKy = reshape(rotKy,size(Y));
rotKz = reshape(rotKz,size(Z));

% img = interp3(Y,X,Z,modelK,rotY,rotX,rotZ,'cubic');
% img = interp3(Y,X,Z,modelK,rotKy,rotKx,rotKz,'linear');

% pjK = interp3(ky,kx,kz,modelK,rotKy,rotKx,rotKz,'linear');
% pjK = interp3(rotKy,rotKx,rotKz,modelK,ky,kx,kz,'linear');
pjK = interp3(ky,kx,kz,modelK,rotKy,rotKx,rotKz,'linear');


pjK(isnan(pjK))=0;
projection = real(my_ifft(pjK(:,:)));

% projection = real(my_ifft(pjK(:,:,nz2+1)));
% projection = squeeze(sum(img,3));
%%




end