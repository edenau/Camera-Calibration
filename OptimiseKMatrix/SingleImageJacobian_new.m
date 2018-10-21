function [ KMatJacob, FrameJacob ] = SingleImageJacobian( KMatrix ,...
    RotAxis, Translation, Correspond, Consensus)
%SingleImageJacobian
% Compute the Jacobian for each image using forward difference
% KMatJacob of size 2n x 5
% FrameJacob of size 2n x 6

% Build newCorrespond that agrees with the param (eliminates noise and
% outliers)
Consensus(Consensus == 0) = [];
n = length(Consensus);
CorrespondIn = zeros(4,n);

for j = 1:n
    CorrespondIn(:,j) = Correspond(:,Consensus(j));
end

% Define Perturbation Size
p = 0.2;  % Perturbation of 10%

% Build Rotation Matrix using Rodrigues
Theta = norm(RotAxis);
RotAxis = RotAxis / norm(RotAxis);
RotMat = Rodrigues(RotAxis,Theta);

% Build Perspectivity in the form [r1;r2;t]
Perspectivity = [ RotMat(:,1:2) , Translation ];

% Extract XY components for convenience
XY = [CorrespondIn(3:4,:);ones(1,n)];

UVEstimated = zeros(3,n);
% Estimate UV using current KMatrix and Perspectivity
Homo = KMatrix * Perspectivity;
for j = 1:n
    UVEstimated(:,j) = Homo * XY(:,j);
    UVEstimated(:,j) = UVEstimated(:,j) / UVEstimated(3,j);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%K. Compute KMatJacob using forward difference

KMatJacob = zeros(2*n,5);

for k = 1:5
    UVPerturbed = zeros(3,n);
    
    KM = KMatrix;
    if k == 1
        ParamChange = KMatrix(1,1) * p;
        KM(1,1) = KMatrix(1,1) + ParamChange;
    elseif k == 2
        ParamChange = KMatrix(1,2) * p;
        KM(1,2) = KMatrix(1,2) + ParamChange;
    elseif k == 3
        ParamChange = KMatrix(1,3) * p;
        KM(1,3) = KMatrix(1,3) + ParamChange;
    elseif k == 4
        ParamChange = KMatrix(2,2) * p;
        KM(2,2) = KMatrix(2,2) + ParamChange;
    elseif k == 5
        ParamChange = KMatrix(2,3) * p;
        KM(2,3) = KMatrix(2,3) + ParamChange;
    end
    
    H = KM * Perspectivity;
    for j = 1:n
        UVPerturbed(:,j) = H * XY(:,j);
        UVPerturbed(:,j) = UVPerturbed(:,j) / UVPerturbed(3,j);
    end
    
    % numerical method - forward diffrentiation
    dUV = (UVPerturbed - UVEstimated) /ParamChange; 
    for j = 1:n
       KMatJacob(j*2-1,k) = dUV(1,j);
       KMatJacob(j*2,k) = dUV(2,j);
    end
end


% K1. Perturb KMatrix elements and store them respectively
% K2. Compute new value of UV using perturbed KMatrix
% K3. Divide by homogenous scaling
% K4. Calculate the gradient for each parameter
% K5. Reshape each param's gradient into a column vector
% K6. Assemble KMatJacob
% K7. Sanity check for size of KMatJacob
[a,b] = size(KMatJacob);
if a ~= 2*n || b~= 5
    error('size of KMatJacob is invalid')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%F. Compute FrameJacob using forward difference

FrameJacob = zeros(2*n,6);

for k = 1:3
    UVPerturbed = zeros(3,n);
    
    RA = RotAxis;
    ParamChange = RotAxis(k) * p;
    RA(k) = RotAxis(k) + ParamChange;
    
    Th = norm(RA);
    RA = RA / norm(RA);
    R = Rodrigues(RA,Th);
    P = [ R(:,1:2) , Translation ];
    H = KMatrix * P;
    
    for j = 1:n
        UVPerturbed(:,j) = H * XY(:,j);
        UVPerturbed(:,j) = UVPerturbed(:,j) / UVPerturbed(3,j);
    end
    
    % numerical method - forward diffrentiation
    dUV = (UVPerturbed - UVEstimated) /ParamChange; 
    for j = 1:n
       FrameJacob(j*2-1,k) = dUV(1,j);
       FrameJacob(j*2,k) = dUV(2,j);
    end
end


for k = 1:3
    UVPerturbed = zeros(3,n);
    
    T = Translation;
    ParamChange = Translation(k) * p;
    T(k) = Translation(k) + ParamChange;
    P = [ RotMat(:,1:2) , T ];
    H = KMatrix * P;
    
    for j = 1:n
        UVPerturbed(:,j) = H * XY(:,j);
        UVPerturbed(:,j) = UVPerturbed(:,j) / UVPerturbed(3,j);
    end
    
    % numerical method - forward diffrentiation
    dUV = (UVPerturbed - UVEstimated) /ParamChange; 
    for j = 1:n
       FrameJacob(j*2-1,k+3) = dUV(1,j);
       FrameJacob(j*2,k+3) = dUV(2,j);
    end
end


end