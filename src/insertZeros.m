function B = insertZeros(A, sizeB, varargin)
%insertZeros inserts an array into a bigger array padded with zeros
%   A: vector or 2D array
%   sizeB: a # or 1-by-2 row vector specifying the size of the output array
%   B: *A* is inserted into a zero matrix of *sizeB* and thus obtaining
%   *B*. By default, the center of *A* coincides with that of *B*.
%
%Optional Input
%   shift: a 1-by-2 row vector specifying the shift of the center of A from
%   center of B.
%
%Remarks
%   method 2 was more general but slower, method 3 only works for
%   arrays of dim =1,2 but faster
%   method 1 in which we post pad the array with zeros and then circshift
%   it was updated to increase computing speed. 
%
%   last updated 07/11/2017
%
%% optional inputs
if length(sizeB) == 1
    sizeB = [sizeB, sizeB];
end

cposB = ceil((sizeB + 1)/2);
if nargin >= 3 && ~isempty(varargin{1})
    cposB = varargin{1} + cposB;
end
%% main
sizeA = size(A);
cposA = ceil((sizeA+1)/2);

B = zeros(sizeB);
rowReg = (cposB(1)-(cposA(1)-1)):(cposB(1)+(sizeA(1)-cposA(1)));
colReg = (cposB(2)-(cposA(2)-1)):(cposB(2)+(sizeA(2)-cposA(2)));
B(rowReg,colReg) = A;
end