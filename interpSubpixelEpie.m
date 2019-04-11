function shiftedObject = interpSubpixelEpie(object, dy, dx)

ndim = size(object,1);
nc = round((ndim+1)./2);
vec = [1:ndim] - nc;

[x, y] = meshgrid(vec,vec);

shiftedObject = interp2(x+dx, y+dy, object, x, y, 'linear', 0);
