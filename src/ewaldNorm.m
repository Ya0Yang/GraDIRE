function [normalized_pattern,k_x,k_y,k_z]  = ewaldNorm(pattern,d,pixel_size,lambda)

%this function normalizes the pixel intensities of a planar detector due to
%curvature of the Ewald sphere
%d is the detector to sample distance in meters
%pixel_size is the edge length of one pixel in meters
%lambda is the wavelength of the x-ray in meters
normalized_pattern = zeros(size(pattern));
n = size(pattern,1);
if mod(n,2) == 0
    n_center = n/2 + 1;
else
    n_center = (n+1) / 2;
end
x_center = n_center;
y_center = n_center;
ind = numel(pattern);
%%

omega_0_0 = pixel_size^2 / d^2; %solid angle of the centro-pixel

for j = 1:ind
    [y_ind x_ind] = ind2sub(size(pattern),j);
    r = sqrt(((x_ind - x_center)*pixel_size).^2 + ((y_ind - y_center)*pixel_size).^2 + d.^2);
    omega = (d * pixel_size^2) ./ (r^3);
    normalized_pattern(j) = pattern(j) .* (omega_0_0 / omega);
end

%% to map the normalized planar detector coordinates to the Ewald sphere

z = 0;
q = 1/lambda;
% k_y = [];
% k_x = [];
% k_z = [];
%intensities = [];

k_y = zeros(size(pattern));
k_x = zeros(size(pattern));
k_z = zeros(size(pattern));



for j = 1:ind
[y_ind x_ind] = ind2sub(size(pattern),j);

r = sqrt((pixel_size*(x_ind-x_center)).^2 + (pixel_size*(y_ind-y_center)).^2);
theta = atand(r / d);
y = -1*(y_ind - y_center);
x = (x_ind - x_center);
phi = atand(y/x);

k_x(j) = q*sind(theta)*cosd(phi);
k_y(j) = q*sind(theta)*sind(phi);
k_z(j) = q*(cosd(theta) - 1);

% k_x(j) = sind(theta)*cosd(phi);
% k_y(j) = sind(theta)*sind(phi);
% k_z(j) = (cosd(theta) - 1);

end
k_x(n_center,n_center) = 0;
k_y(n_center,n_center) = 0;
recip_pixel = k_x(n_center,n_center) - k_x(n_center,n_center-1);
k_x = k_x ./ recip_pixel;
k_y = k_y ./ recip_pixel;
k_z = k_z ./ recip_pixel;

for j = n_center:length(k_x)
    for k = 1:length(k_x)
    k_x(k,j) = -1*k_x(k,j);
    end
end
% k_x = k_x + n_center;
% k_y = k_y + n_center;
k_y(:,1:n_center-1) = flipud(k_y(:,1:n_center-1));

ky = k_x;
kx = k_y;

k_x = kx;
k_y = ky;

