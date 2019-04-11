function image_binned = binner(image)
N = size(image,1);



bin = ones(2,2,2);
image_binned = zeros(N/2,N/2);
iter = 0;
for h = 1:2:N-1
    iter = iter + 1;
    if mod(iter,round(N/10)) == 0
        iter
    end
    for hh = 1:2:N-1
        for hhh = 1:2:N-1
        image_binned(numel(1:2:h),numel(1:2:hh),numel(1:2:hhh)) = sum(sum(sum(image(h:h+1,hh:hh+1,hhh:hhh+1)))) ./ sum(sum(sum(bin)));
        end
    end
end
