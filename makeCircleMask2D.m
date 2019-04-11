function mask = makeCircleMask2D(arraySize,radius)
mask = zeros(arraySize,arraySize);

if mod(arraySize,2) == 0
    nc = arraySize / 2 + 1;
else
    nc = (arraySize+1) ./ 2;
end

[x y] = meshgrid(1:arraySize);

mask(sqrt( (x-nc).^2 + (y-nc).^2) <= radius) = 1;
end



