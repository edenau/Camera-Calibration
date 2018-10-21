function [ ErrorVec ] = ComputeImageErrors(KMatrix, RotAxis, Translation, Correspond, Consensus)

Theta = norm(RotAxis) - 4*pi; % shift the angle back
RotAxis = RotAxis / norm(RotAxis);

R = Rodrigues(RotAxis,Theta);

Perspectivity = [ R(:,1:2) , Translation ];
Homography = KMatrix * Perspectivity;

s = size(Correspond);

% Check Consensus size
EndOfConsensus = 0;
sCon = 0;
while EndOfConsensus == 0 && sCon < s(2)
    if Consensus(sCon+1) == 0
        EndOfConsensus = 1;
    else
        sCon = sCon+1;
    end
end

% initialize
Actual = ones(3,sCon);
Predicted = ones(3,sCon);
for j = 1:sCon
    % obtain the actual [u v 1]'
    Actual(1:2,j) = Correspond(1:2,Consensus(j));

    % obtain [x y 1]' from Correspond
    Predicted(1:2,j) = Correspond(3:4,Consensus(j));
end

for j = 1:sCon
    Predicted(:,j) = Homography * Predicted(:,j);
    % Normalize it
    Predicted(:,j) = Predicted(:,j) / Predicted(3,j);
    Actual(:,j) = Predicted(:,j) - Actual(:,j);
end

ErrorVec = zeros(sCon*2,1); % Initialization
for j = 1:sCon

    ErrorVec(j*2-1,1) = Actual(1,j);
    ErrorVec(j*2,1) = Actual(2,j);

end

end