function [symmetrizedKX,symmetrizedKY,symmetrizedKZ, symmetrizedSetOfPatterns] = applySymmetryOperations(diffractionPatterns,symmetryOperations,indicesKX,indicesKY,indicesKZ)

%%this function takes in a set of diffraction patterns and the
%%corresponding spatial frequency coordinates and computes the symmetry
%%mates
numberOfDiffractionPatterns = size(diffractionPatterns,3);
numberOfSymmetryOperations = size(symmetryOperations,3);

%initialize arrays
symmetrizedKX = zeros(size(diffractionPatterns,1)*size(diffractionPatterns,2),numberOfSymmetryOperations,numberOfDiffractionPatterns);
symmetrizedKY = zeros(size(diffractionPatterns,1)*size(diffractionPatterns,2),numberOfSymmetryOperations,numberOfDiffractionPatterns);
symmetrizedKZ = zeros(size(diffractionPatterns,1)*size(diffractionPatterns,2),numberOfSymmetryOperations,numberOfDiffractionPatterns);
symmetrizedSetOfPatterns = zeros(size(diffractionPatterns,1)*size(diffractionPatterns,2),numberOfSymmetryOperations,numberOfDiffractionPatterns);

for diffractionPatternNumber = 1:numberOfDiffractionPatterns
    kx = indicesKX(:,:,diffractionPatternNumber);kx = kx(:)';
    ky = indicesKY(:,:,diffractionPatternNumber);ky = ky(:)';
    kz = indicesKZ(:,:,diffractionPatternNumber);kz = kz(:)';
    currentDiffractionPattern = diffractionPatterns(:,:,diffractionPatternNumber);
    for symmetryOperationNumber = 1:numberOfSymmetryOperations
    symmetrizedCoordinates = symmetryOperations(:,:,symmetryOperationNumber)*[kx;ky;kz];
    symmetrizedKX(:,symmetryOperationNumber,diffractionPatternNumber) = symmetrizedCoordinates(1,:);
    symmetrizedKY(:,symmetryOperationNumber,diffractionPatternNumber) = symmetrizedCoordinates(2,:);
    symmetrizedKZ(:,symmetryOperationNumber,diffractionPatternNumber) = symmetrizedCoordinates(3,:);
    symmetrizedSetOfPatterns(:,symmetryOperationNumber,diffractionPatternNumber) = currentDiffractionPattern(:);%this is lazy and inefficient to copy the data for each symmetry operation
    end
end

%reshape outputs to be vectors
symmetrizedKX = symmetrizedKX(:)';
symmetrizedKY = symmetrizedKY(:)';
symmetrizedKZ = symmetrizedKZ(:)';
symmetrizedSetOfPatterns = symmetrizedSetOfPatterns(:)';


