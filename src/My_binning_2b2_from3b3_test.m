function BinImg = My_binning_2b2_from3b3_test(Img)
    Dim1 = size(Img,1);
    Dim2 = size(Img,2);
    Dim3 = size(Img,3);
    
    ImgCen = [ceil((Dim1+1)/2) ceil((Dim2+1)/2) ceil((Dim3+1)/2)];
    
    LeftLim1 = ImgCen(1) - floor((ImgCen(1)-1)/(2/3))*2/3;    
    LeftLim2 = ImgCen(2) - floor((ImgCen(2)-1)/(2/3))*2/3;
    LeftLim3 = ImgCen(3) - floor((ImgCen(3)-1)/(2/3))*2/3;
    
    RightLim1 = ImgCen(1) + floor((Dim1-ImgCen(1))/(2/3))*2/3;
    RightLim2 = ImgCen(2) + floor((Dim2-ImgCen(2))/(2/3))*2/3;
    RightLim3 = ImgCen(3) + floor((Dim3-ImgCen(3))/(2/3))*2/3;
    
    LLnum1 = floor((ImgCen(1)-1)/(2/3));
    LLnum2 = floor((ImgCen(2)-1)/(2/3));
    LLnum3 = floor((ImgCen(3)-1)/(2/3));
    
    [Y, X, Z]=meshgrid(1:Dim2,1:Dim1,1:Dim3);
    [Yq, Xq, Zq] = meshgrid(LeftLim2:2/3:RightLim2,LeftLim1:2/3:RightLim1,LeftLim3:2/3:RightLim3);
        
    Vq = interp3(Y,X,Z,Img,Yq,Xq,Zq,'linear');
    
    if sum(isnan(Vq(:))~=0)
        disp('Nan pixels appeared during interpolation!');
    end
    
    BinImg = zeros(floor(Dim1/2)-2,floor(Dim2/2)-2,floor(Dim3/2)-2);
    BinDim1 = size(BinImg,1);
    BinDim2 = size(BinImg,2);
    BinDim3 = size(BinImg,3);
    
    BinImgCen = [ceil((BinDim1+1)/2) ceil((BinDim2+1)/2) ceil((BinDim3+1)/2)];

    for i= -1*(BinImgCen(1)-1):(BinDim1-BinImgCen(1))
        for j=-1*(BinImgCen(2)-1):(BinDim2-BinImgCen(2))
            for k = -1*(BinImgCen(3)-1):(BinDim3-BinImgCen(3)) 
            % Bin the interpolated image 4x4
            currBin = Vq( ( LLnum1 + i*3):( LLnum1 + i*3 + 2), ( LLnum2 + j*3):( LLnum2 + j*3 + 2),( LLnum3 + k*3):( LLnum3 + k*3 + 2)  );
            BinImg(i+BinImgCen(1),j+BinImgCen(2),k+BinImgCen(3)) = sum(currBin(:))/length(currBin(:));            
            end
        end
    end