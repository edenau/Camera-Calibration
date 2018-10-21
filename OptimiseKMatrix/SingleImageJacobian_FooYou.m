function [KMatJacob, FrameJacob] = SingleImageJacobian( KMatrix ,...
    RotAxis, Translation, Correspond, Consensus)
%SingleImageJacobian
% Compute the Jacobian for each image using forward difference
% KMatJacob of size 2n x 5
% FrameJacob of size 2n x 6

% Build newCorrespond that agrees with the param (eliminates noise and
% outliers)
Consensus(Consensus == 0) = [];
newCorrespond = zeros(4,length(Consensus));

for i=1:length(Consensus)
    j = Consensus(i);
    newCorrespond(:,i) = Correspond(:,j);
end

n = length(newCorrespond);

% Define Perturbation Size
p = 1.001;  % Perturbation of 0.1%

% Build Rotation Matrix using Rodrigues
Theta = norm(RotAxis);
RotMat = Rodrigues(RotAxis, Theta);

% Build Perspectivity in the form [r1;r2;t]
Perspectivity = zeros(3);
Perspectivity(:, 1:2) = RotMat(:, 1:2);
Perspectivity(:,3) = Translation;

% Extract newCorrespond xy components for convenience
XY = newCorrespond(3:4,:);
XY(3,:) = 1;

% Estimate UV using current KMatrix and Perspectivity
UVest = KMatrix * Perspectivity * XY;
UVest = UVest(1:2,:)./UVest(3,:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%K. Compute KMatJacob using forward difference
% K1. Perturb KMatrix elements and store them respectively

KMatrix1 = KMatrix;
KMatrix1(1,1) = KMatrix(1,1) * p;
KMatrix2 = KMatrix;
KMatrix2(1,2) = KMatrix(1,2) * p;
KMatrix3 = KMatrix;
KMatrix3(1,3) = KMatrix(1,3) * p;
KMatrix4 = KMatrix;
KMatrix4(2,2) = KMatrix(2,2) * p;
KMatrix5 = KMatrix;
KMatrix5(2,3) = KMatrix(2,3) * p;

% K2. Compute new value of UV using perturbed KMatrix
UVnew1 = KMatrix1 * Perspectivity * XY;
UVnew2 = KMatrix2 * Perspectivity * XY;
UVnew3 = KMatrix3 * Perspectivity * XY;
UVnew4 = KMatrix4 * Perspectivity * XY;
UVnew5 = KMatrix5 * Perspectivity * XY;

% K3. Divide by homogenous scaling
uv1 = UVnew1./UVnew1(3,:);
uv2 = UVnew2./UVnew2(3,:);
uv3 = UVnew3./UVnew3(3,:);
uv4 = UVnew4./UVnew4(3,:);
uv5 = UVnew5./UVnew5(3,:);

% K4. Calculate the gradient for each parameter
dk1 = (uv1(1:2,:) - UVest) / (KMatrix1(1,1) - KMatrix(1,1));
dk2 = (uv2(1:2,:) - UVest) / (KMatrix2(1,2) - KMatrix(1,2));
dk3 = (uv3(1:2,:) - UVest) / (KMatrix3(1,3) - KMatrix(1,3));
dk4 = (uv4(1:2,:) - UVest) / (KMatrix4(2,2) - KMatrix(2,2));
dk5 = (uv5(1:2,:) - UVest) / (KMatrix5(2,3) - KMatrix(2,3));

% K5. Reshape each param's gradient into a column vector
dk1 = reshape(dk1,[],1);
dk2 = reshape(dk2,[],1);
dk3 = reshape(dk3,[],1);
dk4 = reshape(dk4,[],1);
dk5 = reshape(dk5,[],1);

% K6. Assemble KMatJacob
KMatJacob = [dk1, dk2, dk3, dk4, dk5];

% K7. Sanity check for size of KMatJacob
[a,b] = size(KMatJacob);
if a ~= 2*n || b~= 5
    error('size of KMatJacob is wrong')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%F. Compute FrameJacob using forward difference

% Define size FrameJacob
FrameJacob = zeros(2*n, 6);

for i = 1:3
    T = Translation;
    T(i) = Translation(i) * p;
    
    Perspectivity = [RotMat(1:3,1:2), T];
    
    UVnew = KMatrix * Perspectivity * XY;
    
    dTdp = (UVnew(1:2,:)./UVnew(3,:) - UVest) / (T(i) - Translation(i));
    dTdp = reshape(dTdp,[],1); % reshape into column vector
    
    FrameJacob(:,i+3) = dTdp;
end

for i = 1:3
    A = RotAxis;
    A(i) = RotAxis(i) * p;
    
    Theta = norm(A);
    RotMat = Rodrigues(A, Theta);
    Perspectivity = [RotMat(1:3,1:2), Translation];
    
    UVnew = KMatrix * Perspectivity * XY;
    
    dAdp = (UVnew(1:2,:)./UVnew(3,:) - UVest) / (A(i) - RotAxis(i));
    dAdp = reshape(dAdp,[],1); % reshape into column vector
    
    FrameJacob(:,i) = dAdp;
end

end