function [ Grid ] = BuildGridWithLines(Increment,Width)
%BuildGrid
% Grid is 4x2n matrix where each column is a homogenous Point in the objects
% frame. The object is defined as pairs of Points that should have a line
% drawn between them.

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

% Factor is the number of line segment in a complete horizontal/vertical
% line
Factor = Width / Increment;
% Grid that contains 4 rows;
% 2*Factor*(Factor+1)*2 columns
%           - 2 for pair of points which form a line
%           - Factor for number of line segment in a complete horizontal line
%           - Factor+1 for number complete horizontal line for all grids
%           - 2 for horizontal AND vertical lines
NumberColumn = 2*Factor*(Factor+1)*2;
Grid = zeros(4,NumberColumn);
Grid(4,:) = ones(1,NumberColumn);
counter = 0;

% vectors in x direction
for y = 0:Increment:Width
    for x = 0:Increment:(Width-Increment)
        counter = counter +1;
        Grid(1:2,counter) = [x;y];
        counter = counter +1;
        Grid(1:2,counter) = [x+Increment;y];
    end
end

% vectors in y direction
for x = 0:Increment:Width
    for y = 0:Increment:(Width-Increment)
        counter = counter +1;
        Grid(1:2,counter) = [x;y];
        counter = counter +1;
        Grid(1:2,counter) = [x;y+Increment];
    end
end

end