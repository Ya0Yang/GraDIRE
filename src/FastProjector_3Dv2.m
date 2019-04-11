function proj = FastProjector_3Dv2(phi, theta, psi, VI)

N = size(VI,1); Hf = (N-1)/2;
[XI YI ZI] = meshgrid(-Hf:1:Hf,Hf:-1:-Hf,Hf:-1:-Hf);
XI = reshape(XI,1,N*N*N); YI = reshape(YI,1,N*N*N); ZI = reshape(ZI,1,N*N*N);

MRot2 = [ cosd(psi)*cosd(theta)*cosd(phi)-sind(psi)*sind(phi) ,cosd(psi)*cosd(theta)*sind(phi)+sind(psi)*cosd(phi)   ,    -cosd(psi)*sind(theta);
          -sind(psi)*cosd(theta)*cosd(phi)-cosd(psi)*sind(phi), -sind(psi)*cosd(theta)*sind(phi)+cosd(psi)*cosd(phi) ,   sind(psi)*sind(theta)  ;
          sind(theta)*cosd(phi)                               , sind(theta)*sind(phi)                                ,              cosd(theta)];
temp = MRot2*[XI;YI;ZI];
XI = temp(1,:); YI = temp(2,:); ZI = temp(3,:); clear temp;
XI = reshape(XI,N,N,N); YI = reshape(YI,N,N,N); ZI = reshape(ZI,N,N,N);

N2 = round(1.1*N); 
if mod(N2,2) == 0
N2 = N2 + 1;
end
Hf2 = (N2-1)/2; NC2 = (N2+1)/2;
VI2 = zeros(N2,N2,N2);
VI2(NC2-Hf:NC2+Hf,NC2-Hf:NC2+Hf,NC2-Hf:NC2+Hf) = VI;
[X2 Y2 Z2] = meshgrid(-Hf2:1:Hf2,Hf2:-1:-Hf2,Hf2:-1:-Hf2);

VI = interp3(X2,Y2,Z2,VI2,XI,YI,ZI,'linear',-1);
%VI(VI==-1) = 0;
VI(VI < 0) = 0;

proj = sum(VI,3);



