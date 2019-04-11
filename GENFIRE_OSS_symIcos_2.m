%%  GENFIRE_OSS %%

%%inputs:
%%  numIterations - number of iterations to run
%%  support - region of 1's and 0's defining where the reconstruction can exist (voxels that are 0 in support will be set to 0 in reconstruction)
%%  measuredK - measured Fourier points
%%  constraintInd_complex - indices of measuredK that can be enforced as complex (magnitude and phase) values
%%  constraintInd_magnitude - indices of measuredK that can be enforced as magnitude values
%%  R_freeInd_complex - indices of 5% of points in the highest resolution shell of measuredK that are being withheld from 
%%          reconstruction and compared to after iteration. The reconstructability of these points may be used to determine to 
%%          what resolution the input projections are correlated enough to generate a globally consistent reconstruction.
%%  R_freeInd_mag - same as R_freeInd_complex, except these indices correspond to measuredK voxels being withheld that can
%%          only be enforced as magnitudes.

%%outputs:
%%  rec - reconstruction after iteration
%%  errK - reciprocal space error
%%  Rfree_magnitude - value of magnitude Rfree vs iteration

%% Authors: AJ Pryor, Jose Rodriguez
%% Jianwei (John) Miao Coherent Imaging Group
%% University of California, Los Angeles
%% Copyright (c) 2015. All Rights Reserved.
function [rec, errK, Rfree_magnitude,bestErrors] = GENFIRE_OSS_symIcos_2(numIterations,initialObject,support,measuredK,constraintInd_complex,constraintInd_magnitude,R_freeInd_mag,symStart,symEnd)
% showFigure = 0;
load('icosSymmetryOperations.mat');
% symArray = {};
% recArray = {};
errIndex = find(measuredK > 30);
showFigure = 1;
beta = 0.9;
numFilters = 10;
%RecCount =0;
% support = alignByCOMx(support);
% support = alignByCOMy(support);

bestErr = 1e30;%initialize best error
Rfree_magnitude = -1*ones(1,numIterations,'single');%% initialize Rfree_magnitude curve
errK = zeros(1,numIterations,'single');
combinedConstraintInd = union(constraintInd_complex,constraintInd_magnitude);%combined indices of voxels that are enforced in any way
bufferObject = initialObject;
store = 0;


Rsize = size(initialObject,1);
Csize = size(initialObject,2);
Lsize = size(initialObject,3);
Rcenter = round((Rsize+1)/2);
Ccenter = round((Csize+1)/2);
Lcenter = round((Lsize+1)/2);
a=1:1:Rsize;
b=1:1:Csize;
c=1:1:Lsize;
[bb,aa,cc]=meshgrid(b,a,c);
% sigma=(Rsize*resolutionCutoff)/(2*sqrt(2));



X=1:numIterations; 
sigmas=(numFilters+1-ceil(X*numFilters/numIterations))*ceil(numIterations/(1*numFilters)); 
% sigmas=((sigmas-ceil(numIterations/numFilters))*(2*dimx)/max(sigmas))+(20*dimx/10);
% sigmas=((sigmas-ceil(numIterations/numFilters))*(2*dimx)/max(sigmas))+(dimx/60);
sigmas=((sigmas-ceil(numIterations/numFilters))*(2*Rsize)/max(sigmas))+(Rsize/20);

ind = find(support ~=0);    

%% figure(98), plot(X,sigmas), axis tight; title('OSS Filter Size v. Iterations');
totalIterationNum = 1;
for filterNum = 1:numFilters
    filterNum
        kfilter=exp( -( ( ((sqrt((aa-Rcenter).^2+(bb-Ccenter).^2 + (cc-Lcenter).^2)).^2 ) ./ (2* sigmas((filterNum-1)*(numIterations/numFilters)+1).^2) )));
%     kfilter=exp( -( ( ((sqrt((aa-Rcenter).^2+(bb-Ccenter).^2 + (cc-Lcenter).^2)).^2 ) ./ (2* sigmas((filterNum-1)*numIterations+1).^2) )));
    kfilter=kfilter/max(kfilter(:));
%     figure, imagesc(kfilter),axis image
    for iterationNum = 1:numIterations/numFilters
        if mod(iterationNum,10)==0
%             iterationNum
        end
        if totalIterationNum == 1; %for magnitude enforcement, provide random phases for first iteration
            k = my_fft(initialObject);
            rng('shuffle','twister')
            randPhases = single(rand(size(k))*2*pi);
            k(constraintInd_magnitude) = abs(measuredK(constraintInd_magnitude)).*exp(1*i*randPhases(constraintInd_magnitude));
            bestErr = 1e30;%initialize best error
            initialObject = real(my_ifft(k));
        end
        sample = initialObject.*support;
        
     if mod(totalIterationNum,30) == 0 && totalIterationNum > floor(numIterations/20) && totalIterationNum < (numIterations - floor(numIterations/20))
      %symmetrizedRegion = Symm3(sample(257-32:257+32,257-32:257+32,257-32:257+32));
     % symmetrizedRegion = Symm4(sample(257-32:257+32,257-32:257+32,257-32:257+32));
         symmetrizedRegion = Symm4(sample(symStart:symEnd,symStart:symEnd,symStart:symEnd));
     %symmetrizedRegion = sample(257-32:257+32,257-32:257+32,257-32:257+32);
      %symmetrizedRegion = applySymmetry(symmetrizedRegion,icosSymmetryOperations);
      %sample(257-32:257+32,257-32:257+32,257-32:257+32) = symmetrizedRegion;
      sample(symStart:symEnd,symStart:symEnd,symStart:symEnd) = symmetrizedRegion;
     end
%         sample = alignByCOMx(sample);
%         sample = alignByCOMy(sample);
        
        initialObject = bufferObject-beta*initialObject;
        sample(sample<0)=initialObject(sample<0);

        initialObject=single(real(my_ifft(my_fft(initialObject).*kfilter)));
        
            if mod(totalIterationNum,ceil(numIterations/numFilters))==0&&totalIterationNum>10
            
                initialObject=bestRec; 
            else
              initialObject(support==1)=sample(support==1);
            end
            

        bufferObject = initialObject;
        k = my_fft(initialObject);%take FFT of initial object


        %monitor error
        % errK(iterationNum) =sum(abs(k(combinedConstraintInd)-measuredK(combinedConstraintInd)))./sum(abs(measuredK(combinedConstraintInd)));%complex
        ksample = my_fft(sample);
        %errK(totalIterationNum) = sum(abs(abs(ksample(combinedConstraintInd))-abs(measuredK(combinedConstraintInd))))./sum(abs(measuredK(combinedConstraintInd)));%magnitudes only
        errK(totalIterationNum) = sum(abs(abs(ksample(errIndex))-abs(measuredK(errIndex))))./sum(abs(measuredK(errIndex)));
        if nargin > 6 %if values have been withheld from measuredK for monitoring R_free, check them accordingly

            if ~isempty(R_freeInd_mag)
                Rfree_magnitude(iterationNum) = sum(abs(abs(k(R_freeInd_mag))-abs(measuredK(R_freeInd_mag))))./sum(abs(measuredK(R_freeInd_mag)));
            end
        end
        if errK(totalIterationNum)<bestErr&&totalIterationNum >store+2 %if current reconstruction has better error, update best error and best reconstruction
            bestErr = errK(totalIterationNum);
            %rec = applySymmetry(sample,icosSymmetryOperations);
            rec = sample;
%             recArray = [recArray;sample];
            imagesc(sum(rec,3)),axis image
            bestRec = initialObject;
            store=totalIterationNum;
         %  RecCount = RecCount + 1;
        end


            %replace magnitude of measured value with phase of current value
        k(constraintInd_magnitude) = abs(measuredK(constraintInd_magnitude)).*exp(1i*angle(k(constraintInd_magnitude)));
        totalIterationNum = totalIterationNum+1;
        k(constraintInd_complex) = measuredK(constraintInd_complex);%replace complex measured values
        initialObject = real(my_ifft(k));%obtain next object with IFFT
        
        
       if showFigure
        %% figure(3), subplot(1,2,1),plot(errK),subplot(1,2,2), imagesc(squeeze(sum(sample,3)));axis image,title('current object')
       end
    end
    bestErrors(filterNum) = bestErr;
end

