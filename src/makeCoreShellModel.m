function model = makeCoreShellModel(arraySize,cubeSize,kern,pdVal)
n2 = round(cubeSize/2);
nc = round((arraySize+1)/2);
model = zeros(arraySize,arraySize,arraySize);
model(nc-n2:nc+n2,nc-n2:nc+n2,nc-n2:nc+n2) = 79;

if mod(kern,1) == 0
model2 = convn(model,ones(kern,kern,kern),'same')>0;
model2 = double(model2);
diffMap = model2-model;
diffMap(find(diffMap < 1)) = 0;

diffMap(find(diffMap > 1e-30)) = pdVal;

model = model + diffMap;
else 
kern_round = floor(kern);
kern_rem = kern - kern_round;
model2 = convn(model,ones(kern_round,kern_round,kern_round),'same') > 0;
model2 = double(model2);
model3 = convn(model2,ones(3,3,3),'same') > 0;
model3 = double(model3);
diffMap = model2 - model;
diffMap(find(diffMap < 1)) = 0;
diffMap(find(diffMap > 1e-30)) = pdVal;
diffMap2 = model3 - model2;
diffMap2(find(diffMap2 < 1)) = 0;
diffMap2(find(diffMap2 > 1e-30)) = round((pdVal * kern_rem));

model = model + diffMap + diffMap2;
end