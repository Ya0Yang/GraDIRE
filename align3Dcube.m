%Function for alignment

% Img1IN is the reference image
% Img2IN will be align based on Img1IN and saved on ImgOUT

function [ImgOUT]=align3Dcube(Img1IN,Img2IN)

Img1IN = Img1IN/max(max(max(Img1IN)));
Img2IN = Img2IN/max(max(max(Img2IN)));

error = Inf;
L = size(Img1IN);

C = fftshift(ifftn(fftn(Img1IN/max(max(max(Img1IN)))).*conj(fftn(Img2IN)))); % cross correlation
ind = find(C == max(max(max(C))),1,'first'); % maximum cross correlation
[Y,X,Z] = ind2sub(size(C),ind);
X = X - floor(L(2)/2) - 1;
Y = Y - floor(L(1)/2) - 1;
Z = Z - floor(L(3)/2) - 1;
ImgOUT = circshift(Img2IN,[Y X Z]);






%figure; imagesc(squeeze(sum(ImgOUT,3)));
%figure; imagesc(squeeze(sum(Img1IN,3)));