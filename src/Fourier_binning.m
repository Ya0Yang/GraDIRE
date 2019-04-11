function [imgOut] = Fourier_binning(img, binFactor);
%img = im1;
%binFactor = 4;
nc = round((size(img,1)+1)/2);
newX = size(img,2)/binFactor;
tic
convKernel = ones(binFactor,binFactor)./(binFactor.^2);%construct normalized convolution kernel
convKernelPad = zeros(size(img));convKernelPad(nc-binFactor+1:nc,nc-binFactor+1:nc)=convKernel;%pad to same size as image ...
%... important to note that the uppermost pixel of the kernel must be at the center of the padded image
kKernel = my_fft(convKernelPad);

k_new = my_fft(img).*kKernel;%this is equivalent to convolving the real image with our kernel
mask = zeros(size(img));
mask(1:binFactor:end,1:binFactor:end) = 1;%%this accounts for the sampling function which is applied when you obtain a binned image in real space
%by smoothing and then taking every binFactor'th pixel
img2 = real(my_ifft(k_new)).*mask;
k_new = my_fft(img2);

if mod(newX,2)==0 %crop central portion
    k_new = k_new(nc-newX/2:nc+newX/2-1,nc-newX/2:nc+newX/2-1);
else
    k_new = k_new(nc-(newX-1)/2:nc+(newX-1)/2,nc-(newX-1)/2:nc+(newX-1)/2);
end

%FourierSpaceCroppingTime = toc
imgOut = real(my_ifft(k_new));
% figure, 
% subplot(1,2,1),imagesc(imgOut),axis image,title('fourier space cropped')
% %subplot(1,3,2),imagesc(binnedImg),axis image,tmp = caxis;title('real space binned')
% subplot(1,2,2), imagesc(img),axis image
end

function realout = my_ifft(k)
realout =fftshift((ifftn(ifftshift(k))));
end
function kout = my_fft(img)
kout = fftshift(fftn((ifftshift(img))));
end

