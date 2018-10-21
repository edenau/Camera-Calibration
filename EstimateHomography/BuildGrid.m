function [ Grid ] = BuildGrid(Increment,Width)
%BuildGrid
% Grid is 4xn matrix where each column is a homogenous Point in the objects
% frame. The object is defined as the corner Points of each tile.

% Check if both input is positive
if Width <= 0
    error('GridWidth should be positive')
end
if Increment <= 0
    error('GridIncrement should be positive')
end

% Check if the Increment is valid for a given Width
if mod(Width,Increment) ~= 0
    error('Invalid increment')
end

% n is the number of tile in a row/column
n = Width / Increment;
% For Grid, number of rows = 4
% Number of columns is equal to the number of points
% which is (n+1)^2
NumberOfColumn = (n+1)^2;
Grid = zeros(4,NumberOfColumn);
% The 3rd row will remain zeros as the grid is 2D and we set z as constant zero
% The 4th row contains all ones
Grid(4,:) = ones(1,NumberOfColumn);

% A counter that indicates which column should be used to place a new point
cnt = 0;
for y = -Width/2:Increment:Width/2
    for x = -Width/2:Increment:Width/2
        cnt = cnt +1;
        Grid(1:2,cnt) = [x;y];
    end
end

end