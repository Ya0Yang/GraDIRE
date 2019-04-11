function [Err] = refinment(reconstruction,dp_exp,phiMin,phiMax,thetaMin,thetaMax,step,mask)
%mask = importdata('mask.mat');
% reconstruction = importdata('reconstruction.mat');
% dp_exp = importdata('dp.mat');
%dp_exp = sqrt(abs(dp_exp)); %because detector intensity is fourier modulus squared
dp_exp = dp_exp .* mask;
num = 0;
psi = 0;
N = size(dp_exp,1);
nc = round(0.25*N);
nd = round(0.75*N);
for phi = phiMin:step:phiMax
    for theta = thetaMin:step:thetaMax
      
            num = num + 1;
            dp_recon = abs(My_FFTN(FastProjector_3D(phi,theta,psi,reconstruction)));
            dp_recon(find(isnan(dp_recon))) = 0;
            dp_recon = dp_recon .* mask;
            k = normalizer(dp_exp(nc:nd,nc:nd),dp_recon(nc:nd,nc:nd));
            dp_exp_normalized = dp_exp ./ k;
            Err.R(:,num) = R_factor(dp_exp_normalized(nc:nd,nc:nd),dp_recon(nc:nd,nc:nd));
            Err.conf(:,num) = [phi theta psi];
        
    end
end
%save Err.mat Err