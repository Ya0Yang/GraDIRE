function measuredK = assembleFourierGrid_includingSymmetry(diffractionPatterns,eulerAngles,symmetryOperations,interpolationCutoffDistance)
tic%start clock
numberOfDiffractionPatterns = size(diffractionPatterns,3);

for diffractionPatternNumber = 1:numberOfDiffractionPatterns
    
    phi = eulerAngles(1,diffractionPatternNumber);
    theta = eulerAngles(2,diffractionPatternNumber);
    psi = eulerAngles(3,diffractionPatternNumber);

    %% construct rotation matrix
    R = [ cosd(psi)*cosd(theta)*cosd(phi)-sind(psi)*sind(phi) ,cosd(psi)*cosd(theta)*sind(phi)+sind(psi)*cosd(phi)   ,    -cosd(psi)*sind(theta);
          -sind(psi)*cosd(theta)*cosd(phi)-cosd(psi)*sind(phi), -sind(psi)*cosd(theta)*sind(phi)+cosd(psi)*cosd(phi) ,   sind(psi)*sind(theta)  ;
          sind(theta)*cosd(phi)                               , sind(theta)*sind(phi)                                ,              cosd(theta)];
    dim1 = size(diffractionPatterns,1);
    nc = double(round((dim1+1)/2));%center pixel
    n2 = double(nc-1);%radius of array
    [ky, kx] = meshgrid(-n2:n2-1,-n2:n2-1);ky = double(ky);kx = double(kx);
    kx = double(kx(:))';
    ky = double(ky(:))'; %initialize coordinates of unrotated slice
    kz = zeros(1,dim1*dim1,'double'); %0 degree rotation is a projection onto the Y-Z plane, so all points have kx=0;
    rotkCoords = R'*[kx;ky;kz];%rotate coordinates

    indicesKX(:,:,diffractionPatternNumber) = rotkCoords(1,:);%rotated X
    indicesKY(:,:,diffractionPatternNumber) = rotkCoords(2,:);%rotated Y
    indicesKZ(:,:,diffractionPatternNumber) = rotkCoords(3,:);%rotated Z
    
end
    measuredK = zeros(dim1,dim1,dim1,'double');%initialize the array where the interpolated magnitudes will go
    
    %apply symmetry operations
    [symmetrizedKX,symmetrizedKY,symmetrizedKZ, symmetrizedSetOfPatterns] = applySymmetryOperations(diffractionPatterns,symmetryOperations,indicesKX,indicesKY,indicesKZ);

    badInd = find(symmetrizedSetOfPatterns==-1 |  symmetrizedSetOfPatterns<1e-10);%delete values that are flagged as bad

    symmetrizedKX(badInd) = [];
    symmetrizedKY(badInd) = [];
    symmetrizedKZ(badInd) = [];
    symmetrizedSetOfPatterns(badInd) = [];
    
    masterInd = [];%masterInd will be a large list of the grid indices
    masterVals = [];%complex values to include in weighted averaging for those grid points
    masterDistances = [];%distance from measured value to grid point
    
    %search nearby voxels for each grid point and identify all that are
    %within the cutoff distance
    shiftMax = round(interpolationCutoffDistance);
    for Yshift = -shiftMax:shiftMax 
       for Xshift = -shiftMax:shiftMax
           for Zshift = -shiftMax:shiftMax
                tmpX = (round(symmetrizedKX)+Xshift); % apply current shift
                tmpY = (round(symmetrizedKY)+Yshift);
                tmpZ = (round(symmetrizedKZ)+Zshift);
                tmpVals = symmetrizedSetOfPatterns;
                distances = sqrt(abs(symmetrizedKX-tmpX).^2+abs(symmetrizedKY-tmpY).^2+abs(symmetrizedKZ-tmpZ).^2); 
                tmpY = tmpY+nc;%center coordinates for use in the array
                tmpZ = tmpZ+nc;
                tmpX = tmpX+nc;
                goodInd = (~(tmpX>dim1|tmpX<1|tmpY>dim1|tmpY<1|tmpZ>dim1|tmpZ<1)) & distances<=interpolationCutoffDistance;%make sure no indices are outside of the volume
                masterInd = [masterInd sub2ind([dim1 dim1 dim1],tmpX(goodInd),tmpY(goodInd),tmpZ(goodInd))]; %append values to lists
                masterVals = [masterVals tmpVals(goodInd)];
                masterDistances = [masterDistances distances(goodInd)];
           end
       end
    end
clear symmetrizedKX
clear symmetrizedKY
clear symmetrizedKZ
[masterInd sortInd] = sort(masterInd);%organize lists
masterVals = masterVals(sortInd);
masterDistances = masterDistances(sortInd);


[uniqueVals uniqueInd] = unique(masterInd);%find non repeating values. These just have weight of 1 and are fast
uniqueInd(end+1) = length(masterInd)+1;
diffVec = diff(uniqueInd);
singleInd = find(diffVec==1);
measuredK(uniqueVals(singleInd)) = masterVals(uniqueInd(singleInd));

%now deal with grid points with multiple values that are to be weight-averaged by
%their inverse distance
multiInd = find(diffVec~=1);
for index = 1:length(multiInd)-1
    ind = multiInd(index);
    distances = masterDistances(uniqueInd(ind):uniqueInd(ind+1)-1)+1e-30;
    measuredValues = masterVals(uniqueInd(ind):uniqueInd(ind+1)-1);
    weights = ((1./(distances))./sum(((1+1e-30)./(distances))));
    voxel_Mag = sum(weights.*abs(measuredValues));
    measuredK(masterInd(uniqueInd(ind))) = voxel_Mag;
end

    timeTakenToFillInGrid = toc;
    timeTakenToFillInGrid = round(10*timeTakenToFillInGrid)./10;
    fprintf('GENFIRE: Fourier grid assembled in %.12g seconds.\n\n',timeTakenToFillInGrid);

end