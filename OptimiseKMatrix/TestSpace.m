
%input = 2.5;

%step = nuderst(input)

Axis = [0.9982;-0.0481;0.0363];
Angle = 15.6286-4*pi;

R = Rodrigues(Axis,Angle)