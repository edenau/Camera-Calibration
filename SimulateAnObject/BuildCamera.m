function [KMatrix, CameraHeight, CameraWidth] = BuildCamera

%BuildCamera
% Defines the parameters that describes the camera and performs the
% function of a 'definition file'.
%
% It calls SingleVectorCameraModel.m to perform the actual constrcution of
% the K-matrix

% Define parameters
CameraWidth = 720;
CameraHeight = 1280;
FocalLength = 35;
PixelWidth = 0.01;
PixelHeight = 0.01;
Skewness = 0.02;
P_u = 0.5;
P_v = 0.5;

KMatrix = SingleVectorCameraModel([CameraWidth;CameraHeight;FocalLength;PixelWidth;PixelHeight;Skewness;P_u;P_v]);

end

% 8 parameters needed to be defined:
% (1) CameraWidth - An integer describing the number of horizontal pixels.
% (2) CameraHeight - An integer describing the number of vertical pixels.
% (3) FocalLength - The camera focal length (between 1.0 and 100.0 mm)
% (4) PixelWidth - The pixel width (between 0.001 and 0.1 mm)
% (5) PixelHeight - The pixel height (between 0.001 and 0.1 mm)
% (6) Skewness - The skewness in u-pixels (between -0.1 and 0.1)
% (7) P_u - The offset to the principal point as a fraction of the width
% (8) P_v - The offset to the principal point as a fraction of the height