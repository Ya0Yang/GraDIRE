function binned_object= binning3d(pattern,center,xyb,weight)
%%%%%%  nbx,nby,nbz must be odd number  %%%%%%
nbx=xyb(1);
nby=xyb(2);
nbz=xyb(3);
tot=nbx*nby*nbz;
if mod(nbx,2) == 0 || mod(nby,2) ==0 || mod(nbz,2) ==0
error('xyzbin must be odd number');
end
%%%%%%%%%%%%%%                %%%%%%%%%%%%%%
xcenter = center(1);
ycenter = center(2);
zcenter = center(3);

xsize = size(pattern,1);
ysize = size(pattern,2);
zsize = size(pattern,3);
%%%%%%%%%%%%%%                %%%%%%%%%%%%%%
xhalf = min((xcenter-1),(xsize-xcenter));
yhalf = min((ycenter-1),(ysize-ycenter));
zhalf = min((zcenter-1),(zsize-zcenter));
if mod(floor((2*xhalf+1)/nbx),2) == 0
rxhalf = ((floor((2*xhalf+1)/nbx)-1)*nbx-1)/2; 
else
rxhalf =  (floor((2*xhalf+1)/nbx)*nbx-1)/2;  
end

if mod(floor((2*yhalf+1)/nby),2) == 0
ryhalf = ((floor((2*yhalf+1)/nby)-1)*nby-1)/2; 
else
ryhalf =  (floor((2*yhalf+1)/nby)*nby-1)/2;  
end

if mod(floor((2*zhalf+1)/nbz),2) == 0
rzhalf = ((floor((2*zhalf+1)/nbz)-1)*nbz-1)/2; 
else
rzhalf =  (floor((2*zhalf+1)/nbz)*nbz-1)/2;  
end
%%%%%%%%%%%%%%                %%%%%%%%%%%%%%%
pattern_crop = pattern(xcenter-rxhalf:xcenter+rxhalf,ycenter-ryhalf:ycenter+ryhalf,zcenter-rzhalf:zcenter+rzhalf);
%%%%%%%%%%%%%%                %%%%%%%%%%%%%%%
xsize=size(pattern_crop,1);
ysize=size(pattern_crop,2);
zsize = size(pattern_crop,3);
xbsize = floor(xsize/nbx);
ybsize = floor(ysize/nby);
zbsize = floor(zsize/nbz);
binxyz_pattern = zeros(xbsize,ybsize,zbsize);

for hh = 1:xbsize
for kk = 1:ybsize
for ll = 1:zbsize
nx2 = hh*nbx;    
nx1 = nx2-(nbx-1);
ny2 = kk*nby;
ny1 = ny2-(nby-1);
nz2 = ll*nbz;
nz1 = nz2-(nbz-1);
aa1 = 0;
aa2 = 0;
for hh0 = nx1:nx2
for kk0 = ny1:ny2
for ll0 = nz1:nz2
if pattern_crop(hh0,kk0,ll0) ~= -1
aa2 = aa2 + pattern_crop(hh0,kk0,ll0);
aa1 = aa1 + 1;
end
if (aa1/tot)>=weight
binxyz_pattern(hh,kk,ll) = aa2*tot/aa1;
else
binxyz_pattern(hh,kk,ll) = -1;    
end
end
end

end
end
end
end
%%%%%%%%%%%%%%%%%%%%%%              %%%%%%%%%%%%%%%%%%%%
binned_object=binxyz_pattern;