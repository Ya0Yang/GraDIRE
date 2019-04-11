function alignedObject = comAlign(object)

N = size(object,1); nc = (N-1)/2;
[X Y Z] = meshgrid(-nc:1:nc, nc:-1:-nc, nc:-1:-nc);

x_COM = round( sum(object(:).*X(:))/sum(object(:)) );
y_COM = round( sum(object(:).*Y(:))/sum(object(:)) );
z_COM = round( sum(object(:).*Z(:))/sum(object(:)) );

alignedObject = circshift(object, [y_COM -x_COM z_COM]);
