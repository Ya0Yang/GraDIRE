function out = applySymmetry(in,symmetryOperations)
      dim1 = size(in,1);
      if mod(dim1,2)==0;
          padFlag = 1;

      in(end+1,end+1,end+1) = 0;
      else
          padFlag =0;
      end
      out = zeros(size(in));
      numberOfValues = zeros(size(out));
        nc = double(round((dim1+1)/2));%center pixel
        n2 = double(nc-1);%radius of array
%         [Y, X, Z] = meshgrid(-n2:n2-1,-n2:n2-1,-n2:n2-1);Y = double(Y);X = double(X);
        [Y, X, Z] = meshgrid(-n2:n2,-n2:n2,-n2:n2);Y = double(Y);X = double(X);

        X = double(X(:))';
        Y = double(Y(:))'; %initialize coordinates of unrotated slice
        Z = double(Z(:))'; %0 degree rotation is a projection onto the Y-Z plane, so all points have X=0;
%         RotCoordsY = zeros(size(symmetryOperations,3),numel(Y));
%         RotCoordsX = zeros(size(symmetryOperations,3),numel(Y));
%         RotCoordsZ = zeros(size(symmetryOperations,3),numel(Y));

        Xcentered = X+nc;
        Ycentered  = Y+nc;
        Zcentered  = Z+nc;
        ind0 = sub2ind(size(out),Xcentered ,Ycentered ,Zcentered );
    for symmOppNumber = 1:size(symmetryOperations,3)
        R = symmetryOperations(:,:,symmOppNumber);
        RotCoordsTmp = R'*[X;Y;Z];%rotate coordinates
        RotCoordsTmp = round(RotCoordsTmp);
%         RotCoordsY(1,:) = RotCoordsTmp(2,:);
%         RotCoordsX(1,:) = RotCoordsTmp(1,:);
%         RotCoordsZ(1,:) = RotCoordsTmp(3,:);
        ind = sub2ind(size(out),RotCoordsTmp(1,:)+nc,RotCoordsTmp(2,:)+nc,RotCoordsTmp(3,:)+nc);

%         ind = sub2ind(size(out),RotCoordsX+nc,RotCoordsY+nc,RotCoordsZ+nc);

        out(ind0) = out(ind0)  + in(ind);
        numberOfValues(ind0) = numberOfValues(ind0)  + 1;
        
             
             
    end

        out(numberOfValues~=0) = out(numberOfValues~=0) ./ numberOfValues(numberOfValues~=0);
        out(isnan(out)) = 0;
        if padFlag

        out = out(1:end-1,1:end-1,1:end-1);
        end
end