function output = normalization_mask_creator(phi,psi,thickness,mask2)

[x y] = meshgrid(-256:255,-256:255);
norm_mask = zeros(512,512,3);
ind = 0;
for symm = 0:60:120
ind = ind + 1;
    N = length(x);
array = zeros(N,N);
array(abs(x) <= thickness) = 1;

tempx = reshape(x,1,N*N);
tempy = reshape(y,1,N*N);

M = R2D(phi+psi+symm) * [tempx;tempy];

rotx = M(1,:);
roty = M(2,:);

rotx = reshape(rotx,N,N);
roty = reshape(roty,N,N);

rotarray = interp2(x,y,array,rotx,roty);
norm_mask(:,:,ind) = rotarray;
end
norm_mask = sum(norm_mask,3);
norm_mask(norm_mask > 1e-30) = 1;
norm_mask(mask2 == 0) = 0;
norm_mask(isnan(norm_mask) == 1) = 0;
output = norm_mask;