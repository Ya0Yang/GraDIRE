function model = nanoModel(arraySize,cubeSize,shellThickness,pdVal)
%cube size should be odd

model = zeros(arraySize,arraySize,arraySize);
model2 = zeros(arraySize,arraySize,arraySize);

if mod(arraySize,2) == 0
    nc = arraySize / 2 + 1;
else
    nc = (arraySize + 1) / 2;
end
if mod(cubeSize,2) == 0
    ncube = cubeSize / 2;
    model(nc - ncube:nc + (ncube-1),nc - ncube:nc + (ncube-1),nc - ncube:nc + (ncube-1)) = 1;
    nshell = ncube + shellThickness;
    model2(nc - nshell:nc + (nshell-1),nc - nshell:nc + (nshell-1),nc - nshell:nc + (nshell-1)) = 1;
else
    ncube = (cubeSize - 1) / 2;
    model(nc - ncube:nc + ncube,nc - ncube:nc + ncube,nc - ncube:nc + ncube) = 1;
    nshell = ncube + shellThickness;
    model2(nc - nshell:nc + nshell,nc - nshell:nc + nshell,nc - nshell:nc + nshell) = 1;
end


diffmap = (model2 - model) * pdVal;
model = model * 79; %gold
model = model + diffmap;


