% Example script for estimation task 1
%
% This script performs the following actions:
% 1. Constructs a camera model loosely based on an iPhone6
% 2. Constructs a calibration grid 1m on a side with 10mm grid spacing. 
% 3. Positions the grid somewhere in space.
% 4. Places the camera in a'random' location so that the grid
% fills the camera image. Check this location to see if the
% grid outline is outside the image; if not, more the camera nearer
% to the grid. This is NOT a smart way of positioning things, but
% it models the likely behaviour of a human user.
% 5. Compute the image of the grid and constructs a set of grid - image 
% correspondences and add 'noise' ot the image.
% 6. Convert some of the correspondences to outliers.
% 7. Carry out a RANSAC estimation of the homography.

% 1. Construct the Camera model
[KMatrix, CameraHeight, CameraWidth] = BuildCamera;

% 2. Construct a 1m by 1m grid with 10mm tiles in the grid frame
% The grid is a set of 4-element vectors [x y 0 1]'.
GridWidth = 1000;
GridIncrement = 10;
CalibrationGrid = BuildGrid(GridIncrement,GridWidth);

AvgLength = 0;
Max = 0;
for k = 1:1000
% 3. Choose somewhere in space for the grid
% T_ow is the 4x4 transformation matrix from grid to world.
T_ow = PositionGrid();

% 4. Choose a 'random' location for the camera that fills the image.
% T_cw is the 4x4 transformation matrix from camera to world
T_cw = FillImage(T_ow,KMatrix,GridWidth,CameraHeight,CameraWidth);
%ViewCamera(CalibrationGrid(:,1:10200),T_ow,KMatrix,CameraHeight,CameraWidth,T_cw)
% 5. We now fill the camera with a noisy image of the grid and generate the
% point correspondences.
% Correspond is a set of pairs of vectors of the form [[u v]' [x y]'] for
% each grid corner that lies inside the image.
Correspond = BuildNoisyCorrespondence(T_ow,T_cw,CalibrationGrid,KMatrix,CameraHeight,CameraWidth);
l = length(Correspond);
AvgLength = AvgLength + l;
if Max < l
    Max = l;
end
end
AvgLength
Max