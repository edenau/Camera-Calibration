function [ Cube ] = BuildCube
%BuildCube
% Cube is 4x2n matrix where each column is a homogenous Point in the objects
% frame. The object is defined as pairs of Points that should have a line
% drawn between them.

% 4 vectors in each direction,
% i.e. 8 points in each direction (24 points in total needed)
Cube = zeros(4,8*3);
% The last row contains soely the '1' elements
Cube(4,:) = ones(1,8*3);

% a 1m cube
l = 1000;

% vectors in z direction
cnt = 0;
for x = 0:1
    for y = 0:1
        for z = 0:1
            cnt = cnt +1;
            Cube(1:3,cnt) = [x*l;y*l;z*l];
        end
    end
end

% vectors in y direction
for x = 0:1
    for z = 0:1
        for y = 0:1
            cnt = cnt +1;
            Cube(1:3,cnt) = [x*l;y*l;z*l];
        end
    end
end

% vectors in x direction
for z = 0:1
    for y = 0:1
        for x = 0:1
            cnt = cnt +1;
            Cube(1:3,cnt) = [x*l;y*l;z*l];
        end
    end
end

end