%function out = makeCircleMask2(radius,imgSize,ceny,cenx)

function out = makeCircleMask2(radius,imgSize,ceny,cenx)

cent=floor(imgSize/2)+1; 

if nargin < 3
   ceny=cent;
   cenx=cent;
end

out = zeros(imgSize,imgSize);
nc = imgSize/2+1;
n2 = nc-1;
[xx yy] = meshgrid(-n2:n2-1,-n2:n2-1);
R = sqrt(xx.^2 + yy.^2);
out = R<=radius;

out=circshift(out,[-(cent-ceny) -(cent-cenx)]);