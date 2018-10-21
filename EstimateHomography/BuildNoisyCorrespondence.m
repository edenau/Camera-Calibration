function [ Correspond ] = BuildNoisyCorrespondence(T_ow,T_cw,CalibrationGrid,KMatrix,CameraHeight,CameraWidth)
%BuildNoisyCorrespondence
% Takes sets of 4-vectors in world coordinates and computes where they end
% up in the camera image.
%
% The representation is chosen for constructing grid-point to image-point
% correspondences and the points in the form [[u,v]' ; [x,y]'].
%
% Normally distributed noise is added before the correspondences are
% returned to the calling function.


% Compute the positions of the CalibrationGrid in the world coordinates
CalibrationImage = T_ow * CalibrationGrid;

% Compute where corners are in the unit camera frame
CalibrationImage = T_cw \ CalibrationImage;

% Convert to camera pixels
CalibrationImage = KMatrix * CalibrationImage(1:3,:);

s = size(CalibrationImage);
% where s(2) is the number of [u,v]' points
UV = zeros(2,s(2));
    for j = 1:s(2)
        % Normalise to [u,v]
        UV(1:2,j) = CalibrationImage(1:2,j) / CalibrationImage(3,j);     
    end
    
% Noise Generator
Variance = 0.5;
Noise = randn(2,s(2)) * sqrt(Variance);
UV = UV + Noise;

NumberInsideImage = 0;
% InsideImageIndex stores the index of [u,v]' points that are inside the image
InsideImageIndex = zeros(s(2),1);
    for j = 1:s(2)
        % Check the number of [u v]' which is inside the image
        if (UV(1,j) >= 0 && UV(1,j) <= CameraWidth-1) && (UV(2,j) >= 0 && UV(2,j) <= CameraHeight-1)
            NumberInsideImage = NumberInsideImage+1;
            InsideImageIndex(NumberInsideImage,1) = j;
        end
    end

Correspond = zeros(4,NumberInsideImage);
    for j = 1:NumberInsideImage
        Correspond(:,j) = [UV(1:2,InsideImageIndex(j,1)) ; CalibrationGrid(1:2,InsideImageIndex(j,1))];   
    end

end