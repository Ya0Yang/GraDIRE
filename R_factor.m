function R = R_factor(a,b)
% ind = find(a<0);
% a(ind) = 0;
% ind = find(b<0);
% b(ind) = 0;
a = a ./ sum(a(:));
b = b ./ sum(b(:));
R = sum(abs(abs(a(:)) - abs(b(:)))) / sum(abs(a(:)));