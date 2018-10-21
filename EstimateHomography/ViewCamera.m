function [] = ViewCamera(ObjectLines,T_ow,KMatrix,CameraHeight,CameraWidth,T_cw)
%ViewCamera
% Takes an object described by a set of lines passed in ObjectLines and
% draws a picture of the camera's view of the object.
%
% ObjectLines is 4x2n where each column is a homogenous Point in the objects
% frame. The object is defined as pairs of Points that should have a line
% drawn between them.
% T_ow is a 4x4 homogenous transformation matrix descirbing the object's
% frame.
%
% KMatrix is the K-Matrix of the camera in pixels.
% CameraHeight is the number of vertical pixels.
% CameraWidth is the number of horizontal pixels.
% T_cw is the 4x4 Camera frame in world coordinates.

% Check sizes
s = size(ObjectLines);
if s(1) ~=4 || mod(s(2) , 2) ~= 0
    error('ObjectLines has an invalid size')
end

s = size(T_ow);
if s(1) ~=4 || s(2) ~= 4
    error('T_ow has an invalid size')
end

s = size(KMatrix);
if s(1) ~=3 || s(2) ~= 3
    error('KMatrix has an invalid size')
end

s = size(T_cw);
if s(1) ~=4 || s(2) ~= 4
    error('T_cw has an invalid size')
end

% We could perform more tests

% Transform the object into world coordinates
ObjectLines = T_ow * ObjectLines;

% Transform the object into camera coordinates using the backslash operator
ObjectLines = T_cw \ ObjectLines;

% Project out the 4th coordinate and multiply by the KMatrix
ObjectLines = KMatrix * ObjectLines(1:3,:);

% We now have a set of homogenous Points representing 2D points.
% We need to normalize these Points to get 2D points.
s = size(ObjectLines);
for j = 1:s(2)
    ObjectLines(1:2,j) = ObjectLines(1:2,j) / ObjectLines(3,j);
end

% Throw away the normalising componenets
ObjectLines = ObjectLines(1:2,:);

% Generating the image
figure(1)
clf

axis([0 CameraWidth 0 CameraHeight])
hold on
% Count through the Point pair
for j = 1 : 2 : s(2)
    plot([ObjectLines(1,j) ObjectLines(1,j+1)] , [ObjectLines(2,j) ObjectLines(2,j+1)],'.')
end

axis ij

end