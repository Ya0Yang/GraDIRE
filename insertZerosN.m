function B = insertZerosN(A, sizeB, varargin)
%insertZerosN inserts an array into a bigger array padded with zeros
%   A: N-dimensional array
%   sizeB: a 1-by-N row vector specifying the size of the output array
%   B: *A* is inserted into a zero matrix of *sizeB* and thus obtaining
%   *B*. By default, the center of *A* coincides with that of *B*.
%
%Optional Input
%   shift: a 1-by-N row vector specifying the shift of the center of A from
%   center of B.
%
%Remarks
%   old method in which we post pad the array with zeros and then circshift
%   it was updated to increase computing speed. 
%   speed improved, but still slow when dealing with large arrays
%
%   last updated 07/11/2017
%% optional inputs
cposB = ceil((sizeB + 1)/2);
if nargin >= 3 && ~isempty(varargin{1})
    cposB = varargin{1} + cposB;
end

%% main
sizeA = size(A);
cposA = ceil((size(A)+1)/2);
B = padarray(A, sizeB - cposB - (sizeA - cposA), 'post');
B = padarray(B, cposB - cposA, 'pre');
end

