function [pixelPositions,rotatedPositions, bigx, bigy] = ...
    convert_to_pixel_positions_testing6(positions,pixel_size,little_area,rot_deg)
        R = [cosd(rot_deg) -sind(rot_deg);sind(rot_deg) cosd(rot_deg)]; %rotation matrix
        
        
        pixelPositions = positions./pixel_size;
        pixelPositions(:,1) = (pixelPositions(:,1)-min(pixelPositions(:,1))); %x goes from 0 to max
        pixelPositions(:,2) = (pixelPositions(:,2)-min(pixelPositions(:,2))); %y goes from 0 to max
        pixelPositions(:,1) = (pixelPositions(:,1) - round(max(pixelPositions(:,1))/2)); %x is centrosymmetric around 0
        pixelPositions(:,2) = (pixelPositions(:,2) - round(max(pixelPositions(:,2))/2)); %y is centrosymmetric around 0
        
        % rotated positions for sub modes
        rotatedPositions = (R*pixelPositions')';
        %
        
        bigx = little_area + round(max(max(pixelPositions(:),rotatedPositions(:))))*2+10; % Field of view for full object
        bigy = little_area + round(max(max(pixelPositions(:),rotatedPositions(:))))*2+10;
        big_cent = floor(bigx/2)+1;
        
        pixelPositions = pixelPositions + big_cent;
        rotatedPositions = rotatedPositions + big_cent;
        
    end