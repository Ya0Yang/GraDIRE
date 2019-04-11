function [alignedObject,varargout] = comAlign2D(object)

N = size(object,1); nr = round((N+1)/2); nc = (nr-1);
if mod(N,2) == 0
[X Y] = meshgrid(-nc:nc-1, (nc-1):-1:-nc);
else
[X Y ] = meshgrid(-nc:1:nc, nc:-1:-nc);
end
x_COM = round( sum(object(:).*X(:))/sum(object(:)) );
y_COM = round( sum(object(:).*Y(:))/sum(object(:)) );
alignedObject = circshift(object, [y_COM -x_COM ]);
varargout{1} = y_COM; varargout{2} = -x_COM;