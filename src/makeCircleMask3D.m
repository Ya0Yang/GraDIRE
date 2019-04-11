function mask = makeCircleMask3D(arraySize,radius)
mask = zeros(arraySize,arraySize,arraySize);

if mod(arraySize,2) == 0
    nc = arraySize / 2 + 1;
else
    nc = (arraySize+1) ./ 2;
end

[x y z] = meshgrid(1:arraySize);

mask(sqrt( (x-nc).^2 + (y-nc).^2 + (z-nc).^2) <= radius) = 1;
end



