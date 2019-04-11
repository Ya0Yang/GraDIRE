function M = MatrixQuaternionRot2(phi,theta,psi)

phi = phi*pi/180;
theta = theta*pi/180;
psi = psi*pi/180;
vector = [sin(theta)*cos(phi) sin(theta)*sin(phi) cos(theta)];
w = cos(psi/2); x = -sin(psi/2)*vector(1); y = -sin(psi/2)*vector(2); z = -sin(psi/2)*vector(3);
RotM = [1-2*y^2-2*z^2 2*x*y+2*w*z 2*x*z-2*w*y;
      2*x*y-2*w*z 1-2*x^2-2*z^2 2*y*z+2*w*x;
      2*x*z+2*w*y 2*y*z-2*w*x 1-2*x^2-2*y^2;];

Ry = [cos(theta) 0 sin(theta);
      0 1 0;
      -sin(theta) 0 cos(theta);];
Rz = [cos(phi) -sin(phi) 0;
      sin(phi) cos(phi) 0;
      0 0 1;];
M = RotM*Rz*Ry;

end