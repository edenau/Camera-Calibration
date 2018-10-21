function [ Fac ] = CheckifSmall_disabled(TheValue)

Fac = 5000;

if TheValue < 0.0005
    Fac = Fac/1;
elseif TheValue < 0.001
    Fac = Fac/2;
elseif TheValue < 0.005
    Fac = Fac/4;
elseif TheValue < 0.01
    Fac = Fac/8;
elseif TheValue < 0.5
    Fac = 1.5;
else Fac = 1;
end

%Fac = max(0.01/TheValue,0.2);
%Fac = max(1e-4/abs(TheValue),abs(TheValue)*0.01);
end