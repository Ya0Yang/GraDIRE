function Psi = convSubpixelEpie(object,probe,dy,dx)
ny = size(object,1); nx = size(object,2);
[X, Y] = meshgrid(-nx/2:nx/2-1,-ny/2:ny/2-1);
Probe = my_fft(probe);
ObjectShifted = my_fft(object).*exp(2*pi*1i*(dx*X/nx + dy*Y/ny));
PsiTemp = conv2(ObjectShifted,Probe,'same');
Psi = PsiTemp.*exp(-2*pi*1i*(dx*X/nx + dy*Y/ny)); 