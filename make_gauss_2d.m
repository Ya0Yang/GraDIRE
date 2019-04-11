%% make_gauss creates a L1-normalized gaussian of size 2n+1 with defined sigma
function [ Gauss ] = make_gauss_2d( n,sigma )
    vec = (1:n) - round((n+1)/2);
   [xx,yy]  = meshgrid(vec,-vec);
    G = exp(-(xx.^2 + yy.^2) ./ (sigma)^2);
    Gauss = G ./ norm(G(:),1);
end