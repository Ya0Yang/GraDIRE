function alignedObject = comAlign2(object)

N = size(object,1); nr = round((N+1)/2); nc = (nr-1);
if mod(N,2) == 0
[X Y Z] = meshgrid(-nc:nc-1, (nc-1):-1:-nc, (nc-1):-1:-nc);
else
[X Y Z] = meshgrid(-nc:1:nc, nc:-1:-nc, nc:-1:-nc);
end
x_COM = round( sum(object(:).*X(:))/sum(object(:)) );
y_COM = round( sum(object(:).*Y(:))/sum(object(:)) );
z_COM = round( sum(object(:).*Z(:))/sum(object(:)) );

alignedObject = circshift(object, [y_COM -x_COM z_COM]);
