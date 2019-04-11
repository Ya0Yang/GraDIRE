% function [probe_in,probe_mask,centers,radii] = create_probe_guess(diffpats,threshold,mask_radius_factor,pinholes,px_size,frame)
function [probe_in,probe_mask,centroids,radii] = create_probe_guess_Arjun(dps)
% create probe_in with autocorrelation
% threshold=.01;
threshold = 0.075;
aa=abs(my_fft(mean(dps.^2,3)));
aa=aa>max(aa(:))*threshold;
center=floor(size(dps,1)/2)+1;

stats=regionprops(aa,'centroid','majoraxislength');
centroids=round(cat(1,stats.Centroid)); % [x,y]
radii=round(cat(1,stats.MajorAxisLength)./4); % radius
%xshift=round(abs((centroids(1,1)-centroids(2,1))/2));
%yshift=round(abs((centroids(1,2)-centroids(2,2))/2)); commented out by
%Arjun 02/02/2017
xshift = 0;
yshift = 0;
stats = stats(1);    
if length(stats) > 2 % dual pinhole
    probe_in=makeCircleMask2(min(radii),size(dps,1),center+xshift,center-yshift)...
        + makeCircleMask2(min(radii),size(dps,1),center-xshift,center+yshift);
    dilation_size=60; %px
    probe_mask=imdilate(probe_in,makeCircleMask2(dilation_size,2*dilation_size));
    
    probe_in=flipud(probe_in);
    probe_mask=flipud(probe_mask);
else % single pinhole
    probe_in=makeCircleMask2(max(radii),size(dps,1));
    dilation_size=60; %px
    probe_mask=imdilate(probe_in,makeCircleMask2(dilation_size,2*dilation_size));    
end

% % method 2 (old)
% aa=abs(my_fft(mean(diffpats,3).^2));
% aa=aa>max(aa(:))*threshold;
% 
% stats=regionprops(bwlabel(aa),'centroid','area','majoraxislength');
% area=[stats.Area];
% centers=round(cat(1,stats.Centroid)); % [x,y]
% radii=round(cat(1,stats.MajorAxisLength)./4); % radius
% 
% if strcmp(pinholes,'two')
%     shift=abs((centers(1,1)-centers(2,1))/2); % center
%     centers(:,1)=round(centers(:,1)+shift);
% end
% 
% if strcmp(pinholes,'two')
%     for n=1:2
%         probe_in(:,:,n)=makeCircleMask2(radii(1),length(aa),centers(n,2),centers(n,1)); % use half the radius to create initial guess
%         probe_mask(:,:,n) = makeCircleMask2(radii(1)*mask_radius_factor,length(diffpats),centers(n,2),centers(n,1));
%     end
% else
%    for n=1
%         probe_in(:,:,n)=makeCircleMask2(radii(1),length(aa),centers(n,2),centers(n,1)); % use half the radius to create initial guess
%         probe_mask(:,:,n) = makeCircleMask2(radii(1)*mask_radius_factor,length(diffpats),centers(n,2),centers(n,1));
%    end 
% end
% 
% probe_in=sum(probe_in,3);
% probe_mask=sum(probe_mask,3) ~= 0;
% 
% % create binary initial probe guess
% probe_in=denoise(probe_in,2);
% probe_in = probe_in.*exp(2i*rand(size(probe_in))*pi/10);
% 
% figure(200),clf
% subplot(121),imagesc(aa),axis image;title('mask from autocorrelation')
% subplot(122),phplot(probe_in+probe_mask),axis image;title('probe in + probe mask')

