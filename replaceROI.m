%replaces the center m x m pixels of a larger N x N array with values given
%by 'ROI'

function updatedObj = replaceROI(object,ROI)
    updatedObj = object;
    ndim = size(object,1);
    nc = round((ndim+1)/2);
    
    nROI = size(ROI,1);
    rROI = floor(nROI/2);
    if mod(nROI,2) == 0
        updatedObj(nc-rROI:nc+rROI-1,nc-rROI:nc+rROI-1) = ROI;
    else
        updatedObj(nc-rROI:nc+rROI,nc-rROI:nc+rROI) = ROI;
    end
end
