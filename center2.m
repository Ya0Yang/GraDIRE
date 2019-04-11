function [output] = center2(reference,diffpats)
%{
2015-04-24 by Zhaolingrong 
modified 2018-05-30 by Arjun Rana
This function is to find the center of a diffraction pattern. A low
exposure time pattern is recommended.

Amplitude: a diffraction pattern;
range:     the parameter to define fit-area around the peak point.
%}

BackGround=0;
range = 40; % defines the range around DC term to do the Gaussian fitting
x=double(sum(reference,1));
y=double(sum(reference,2));
[max_X,xc]=max(x);
[max_Y,yc]=max(y);

%% define the fit type and fit option
fx = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,0,0],...
               'Upper',[Inf,Inf,Inf,Inf],...
               'StartPoint',[max_X,xc,60,0]);
ftx = fittype('a*exp(-((x-b)/c)^2)+d','options',fx);
fy = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,0,0],...
               'Upper',[Inf,Inf,Inf,Inf],...
               'StartPoint',[max_Y,yc,60,0]);
fty = fittype('a*exp(-((x-b)/c)^2)+d','options',fy);

%% carry out the fit task and show the result, a pattern with center pixel settled to zero will be shown
% fit Gaussian along x-axis
figure(1);clf
subplot(1,2,1)
plot(x,'.');title('x fit')
tx=1:length(x);
tx=tx';
[cfun,~] = fit(tx(xc-range:xc+range),x(xc-range:xc+range)',ftx);
yx = cfun.a*exp(-((tx-cfun.b)/cfun.c).^2)+cfun.d;
hold on ;
plot(tx,yx,'r','LineWidth',2);
centerX=round(cfun.b);

%  fit Gaussian along y-axis
subplot(1,2,2)
ty=1:length(y);
ty=ty';
plot(y,'.');title('y fit')
[cfun2,~] = fit(ty(yc-range:yc+range),y(yc-range:yc+range),fty);
yy = cfun2.a*exp(-((ty-cfun2.b)/cfun2.c).^2)+cfun2.d;
hold on ;
plot(ty,yy,'r','LineWidth',2);
drawnow
% ccc=input('Is the fit results apropriate? If not pess Ctr+C, ohterwise, press Enter ');
centerY=round(cfun2.b);
center=[centerY,centerX];

% in = input(sprintf('Enter known center [x,y] or 0 to use fitted center (fitting: [%d %d]): ',centerX,centerY));
% if numel(in) ~= 2 || in(1) == 0
%     center=[centerY,centerX];
% else 
%     center = in;
% end

Lxy = 2*center-1-size(reference);

%% add zero pixels to adjust the diffraction center to the center of a image with new size
for ii = 1:size(diffpats,3)
    reference = diffpats(:,:,ii);
if Lxy(1)<0
    buffer=cat(1,zeros(abs(Lxy(1)),size(reference,2))+BackGround,reference);
    if Lxy(2)<0
        buffer_2=cat(2,zeros(size(buffer,1),abs(Lxy(2)))+BackGround,buffer);
    elseif Lxy(2)>0
        buffer_2=cat(2,buffer,zeros(size(buffer,1),Lxy(2))+BackGround);
    end
elseif Lxy(1)>0
    buffer=cat(1,reference,zeros(Lxy(1),size(reference,2))+BackGround);
    if Lxy(2)<0
        buffer_2=cat(2,zeros(size(buffer,1),abs(Lxy(2)))+BackGround,buffer);
    elseif Lxy(2)>0
        buffer_2=cat(2,buffer,zeros(size(buffer,1),Lxy(2))+BackGround);
    end
% else
%     buffer_2=
end

%% add zeros to adjust the pattern to a square matrix
sizeF2D = size(buffer_2);
ll=abs(sizeF2D(1)-sizeF2D(2));
if mod(ll,2)==0
   if sizeF2D(1)>sizeF2D(2)
       add_zero = zeros(sizeF2D(1),ll/2)+BackGround;
       buffer3 = cat(2,add_zero,buffer_2,add_zero);
   elseif sizeF2D(1)<sizeF2D(2)
       add_zero=zeros(ll/2,sizeF2D(2))+BackGround;
       buffer3 = cat(1,add_zero,buffer_2,add_zero);
   else
       buffer3 = buffer_2;
   end
else
   if sizeF2D(1)<sizeF2D(2)
       add_zero1 = zeros(sizeF2D(1),ll/2)+BackGround;
       add_zero2 = zeros(sizeF2D(1),ll/2+1)+BackGround;
       buffer3 = cat(2,add_zero1,buffer_2,add_zero2);
   elseif sizeF2D(1)>sizeF2D(2)
       add_zero1=zeros(ll/2,sizeF2D(2))+BackGround;
       add_zero2=zeros(ll/2+1,sizeF2D(2))+BackGround;
       buffer3 = cat(1,add_zero1,buffer_2,add_zero2);
   else
       buffer3 = buffer_2;
   end 
end
%% crop out central square of diffraction pattern
buffer3 = croppedOut(buffer3,min(size(reference)));
%% output 
% figure(99)
% buffer3(buffer3<0)=0;
output(:,:,ii)=buffer3;
% imagesc(abs(output(:,:,ii)));axis image
% drawnow
% diffpats(:,:,1) = []
% pause(0.5)
end

%% check the centering by re-fitting pattern again
result = sum(output,3);
x=double(sum(result,1));
y=double(sum(result,2));
[max_X,xc]=max(x);
[max_Y,yc]=max(y);


% define the fit type and fit option
fx = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,0,0],...
               'Upper',[Inf,Inf,Inf,Inf],...
               'StartPoint',[max_X,xc,60,0]);
ftx = fittype('a*exp(-((x-b)/c)^2)+d','options',fx);
fy = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,0,0],...
               'Upper',[Inf,Inf,Inf,Inf],...
               'StartPoint',[max_Y,yc,60,0]);
fty = fittype('a*exp(-((x-b)/c)^2)+d','options',fy);

tx=1:length(x);
tx=tx';
[cfun,~] = fit(tx(xc-range:xc+range),x(xc-range:xc+range)',ftx);
centerX=round(cfun.b);

%  fit Gaussian along y-axis
ty=1:length(y);
ty=ty';
[cfun2,~] = fit(ty(yc-range:yc+range),y(yc-range:yc+range),fty);
centerY=round(cfun2.b);

fprintf('Check goodness of fit: center: (%d, %d), should be (%d, %d) \n',centerX,centerY,floor(size(output,1)/2)+1,floor(size(output,2)/2)+1);
   
end
