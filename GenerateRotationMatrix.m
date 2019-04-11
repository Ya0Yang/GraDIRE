function R = GenerateRotationMatrix(angleVector)

rotPhi = angleVector(1); rotTheta = angleVector(2); rotPsi = angleVector(3);

R = [ cosd(rotPsi)*cosd(rotTheta)*cosd(rotPhi)-sind(rotPsi)*sind(rotPhi) ,cosd(rotPsi)*cosd(rotTheta)*sind(rotPhi)+sind(rotPsi)*cosd(rotPhi)   ,    -cosd(rotPsi)*sind(rotTheta);
          -sind(rotPsi)*cosd(rotTheta)*cosd(rotPhi)-cosd(rotPsi)*sind(rotPhi), -sind(rotPsi)*cosd(rotTheta)*sind(rotPhi)+cosd(rotPsi)*cosd(rotPhi) ,   sind(rotPsi)*sind(rotTheta)  ;
          sind(rotTheta)*cosd(rotPhi)                               , sind(rotTheta)*sind(rotPhi)                                ,              cosd(rotTheta)];
end