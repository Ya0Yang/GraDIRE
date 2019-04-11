function [ HDR_F2D , residual,stDev,Npix ] = HDR_LRZ( F2D,ratio_definition)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

low_ratio = ratio_definition(1);
high_ratio = ratio_definition(2);
maximum = max(F2D(:));
diff = (F2D(:,:,2));

%% define 'High' channel
High = diff>=maximum*high_ratio;
High = conv2(single(High),ones(10,'single'),'same')~=0;

%% define 'Low' channel
cc = F2D(:,:,2)<maximum*low_ratio;
cc2 = F2D(:,:,3) > maximum*high_ratio;
cc2 = conv2(single(cc2),ones(10,'single'),'same')~=0;

cc = (cc -cc2) == 1;
Low = (cc-High) == 1;

%% define 'Medium' channel
Medium  = 1-Low-High;

%%% view progress
% F2D2=F2D;
% F2D2(F2D2<0)=0;
% figure(12),colormap jet
% subplot(231),imagesc(log(1+F2D2(:,:,1)));axis image
% subplot(232),imagesc(log(1+F2D2(:,:,2)));axis image
% subplot(233),imagesc(log(1+F2D2(:,:,3)));axis image
% subplot(234),imagesc(High);axis image; title('High mask')
% subplot(235),imagesc(Medium);axis image; title('Medium mask')
% subplot(236),imagesc(Low);axis image; title('Low mask')

%% define scaling_region
LL = F2D(:,:,1)>maximum*low_ratio;
HH = F2D(:,:,3)<maximum*high_ratio;
scalingRegion = LL.*HH; 
Npix = sum(sum(scalingRegion));
% figure(2),imagesc(scalingRegion),axis image,title('scaling region')
%%
scaling = sum(sum(F2D(:,:,3).*scalingRegion));

for i = 1:3
    aa = scaling./sum(sum((F2D(:,:,i).*scalingRegion)));
    F2D(:,:,i) = F2D(:,:,i)*aa;
end

%%% calculate residuals and standard deviations
a1 = 2*sum(sum(abs((F2D(:,:,1)-F2D(:,:,2)).*scalingRegion)))./sum(sum((F2D(:,:,2)+F2D(:,:,1)).*scalingRegion));
acc1 = std2(abs(F2D(:,:,1)-F2D(:,:,2)).*scalingRegion);
a2 = 2*sum(sum(abs((F2D(:,:,3)-F2D(:,:,2)).*scalingRegion)))./sum(sum((F2D(:,:,2)+F2D(:,:,3)).*scalingRegion));
acc2 = std2(abs(F2D(:,:,3)-F2D(:,:,2)).*scalingRegion);
residual = (a1+a2)/2;
stDev = (acc1+acc2)/2;

%%% combine to form HDR image
HDR_F2D = F2D(:,:,1).*High + F2D(:,:,2).*Medium + F2D(:,:,3).*Low;

% figure(13)
% imagesc(log(1+abs(HDR_F2D)));axis image; colormap jet
end
