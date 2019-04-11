%%normalizes pixel values between two images using least squares method
%%assuming that the two images (A,B) are related by (A-kB) = 0 where k is a
%%constant
%%note: use a mask on A and B to segregate a high quality region for
%%comparison 
function k = normalizer(A,B);
x = sum(dot(conj(A),B));
y = sum(dot(A,conj(B)));
q = 2 .* sum(dot(B,conj(B)));
k = (x+y) ./ q;
k = 1/k;
