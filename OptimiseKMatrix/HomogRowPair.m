function [ Regressor , DataVec ] = HomogRowPair(SamplePoint)
%HomogRowPair
% Implementing mathematical functions with complex entries

u = SamplePoint(1);
v = SamplePoint(2);
x = SamplePoint(3);
y = SamplePoint(4);

Regressor = [ x y 1 0 0 0 -u*x -u*y;
              0 0 0 x y 1 -v*x -v*y];
          
DataVec = [u;v];

end