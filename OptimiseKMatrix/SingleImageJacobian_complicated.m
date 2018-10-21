function [ KMatJacob,FrameJacob ] = SingleImageJacobian(KMatrix, RotAxis, Translation, Correspond, Consensus)

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
UVActual = ones(3,sCon);
XY = ones(3,sCon);
for j = 1:sCon
    % obtain the actual [u v 1]'
    %UVActual(1:2,j) = Correspond(1:2,Consensus(j));

    % obtain [x y 1]' from Correspond
    XY(1:2,j) = Correspond(3:4,Consensus(j));
end
UVPerturbed = zeros(3,sCon);


Theta = norm(RotAxis) - 4*pi;
RotAxis = RotAxis / norm(RotAxis);
R = Rodrigues(RotAxis,Theta);
Persp = [ R(:,1:2) , Translation ];

Homo = KMatrix * Persp;
for j = 1:sCon
    UVActual(:,j) = Homo * XY(:,j);
    UVActual(:,j) = UVActual(:,j) / UVActual(3,j);
end

KMatJacob = zeros(2*sCon,5);
for k = 1:5
    [KMatPerturbed,dp] = KMatPerturbation(KMatrix,k); % forward
    Homo = KMatPerturbed * Persp;
    for j = 1:sCon
        UVPerturbed(:,j) = Homo * XY(:,j);
        UVPerturbed(:,j) = UVPerturbed(:,j) / UVPerturbed(3,j);
    end
    
    % numerical method - forward diffrentiation
    dUV = (UVPerturbed - UVActual)/dp; 
    for j = 1:sCon
       KMatJacob(j*2-1,k) = dUV(1,j);
       KMatJacob(j*2,k) = dUV(2,j);
    end
end

% ------------------------- This is a separation line -------------------------

FrameJacob = zeros(2*sCon,6);
for k = 1:3
    [RAPerturbed,dp] = VectorPerturbation(RotAxis,k);
    Theta = norm(RAPerturbed) - 4*pi;
    RAPerturbed = RAPerturbed / norm(RotAxis);
    R = Rodrigues(RAPerturbed,Theta);
    Persp = [ R(:,1:2) , Translation ];
    Homo = KMatrix * Persp;
    
    for j = 1:sCon
        UVPerturbed(:,j) = Homo * XY(:,j);
        UVPerturbed(:,j) = UVPerturbed(:,j) / UVPerturbed(3,j);
    end
    
    % numerical method - forward diffrentiation
    dUV = (UVPerturbed - UVActual)/dp; 
    for j = 1:sCon
       FrameJacob(j*2-1,k) = dUV(1,j);
       FrameJacob(j*2,k) = dUV(2,j);
    end
end

Theta = norm(RotAxis) - 4*pi;
RotAxis = RotAxis / norm(RotAxis);
R = Rodrigues(RotAxis,Theta);
for k = 1:3
    [TransPerturbed,dp] = VectorPerturbation(Translation,k);
    Persp = [ R(:,1:2) , TransPerturbed ];
    Homo = KMatrix * Persp;
    
    for j = 1:sCon
        UVPerturbed(:,j) = Homo * XY(:,j);
        UVPerturbed(:,j) = UVPerturbed(:,j) / UVPerturbed(3,j);
    end
    
    % numerical method - forward diffrentiation
    dUV = (UVPerturbed - UVActual)/dp; 
    for j = 1:sCon
       FrameJacob(j*2-1,k+3) = dUV(1,j);
       FrameJacob(j*2,k+3) = dUV(2,j);
    end
end


end