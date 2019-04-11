%shifted_array = scale_array;
tic
    A = complex_image;
    B = new_obj;
    C = rot90(rot90(new_obj));
    [sizey ,sizex] = size(complex_image);
    cent = floor(sizey/2) + 1;
    
cc1 = abs(my_ifft(my_fft(angle(A)).*conj(my_fft(angle(B)))));
cc2 = abs(my_ifft(my_fft(angle(A)).*conj(my_fft(angle(C)))));

b = find(cc1 == max(max(cc1)));
d = find(cc2 == max(max(cc2)))
temp = zeros(sizey,sizex);
if max(max(cc1)) > max(max(cc2))
    temp(b) = 100;
    [x ,y] = find(temp ==100);
    offset = [x ,y] - cent;
    shifted_array = circshift(B,[offset(2) offset(1)]);
else
    temp(d) = 100;
    [x ,y] = find(temp ==100);
    offset = [x ,y] - cent;
    shifted_array =circshift(C,[offset(2) offset(1)]);
end
 figure(1)
 subplot(1,2,1)
 imagesc(abs(B)); axis image; colormap jet; title('uncentred')
 subplot(1,2,2)
 imagesc(abs(shifted_array)); axis image; colormap jet; title('centred')
 pause(0.5)
%clear A B C cc1 cc2 b d temp offset x y

time = toc
