function [Acc,T,Q,DQ,D2Q] = main_1()
% Out:
%   T   - an array containing time instances.
%   Q   - an array containing positions in subsequent time instances.
%   DQ  - an array containing velocities in subsequent time instances.
%   D2Q - an array containing accelerations in subsequent time instances.
%In:
load('Data.sql')
Om = [0 -1;
      1  0];  % Auxiliary matrix
  
  q=[-1.2;0.6;0;
   -0.7;0.85;0;
   0.4;0.65;0;
   -0.35;0.4;0;
   0.1;0.9;0;
   -0.4;0.65;0;
   0.15;0.4;0;
   0.25;0;0;
   0.05;0.15;0;
   0.35;0.05;0];
  
A = [-1.2;0.3];
B = [-1.1;0.9];
D = [-0.4;0.5];
E = [-0.4;0.8];
F = [0.6;0.9];
G = [0.1;0.6];
H = [0.3;-0.2];
J = [-0.4;0.9];
K = [-1.3;0.7];
M = [-0.1;0.2];
N = [0.5;0];
O = [0.5;0.5];
R = [0.4;0.5];

c0 = [0;0];
c1 = [-1.2;0.6];
c2 = [-0.7;0.85];
c3 = [0.4;0.65];
c4 = [-0.35;0.4];
c5 = [0.1;0.9];
c6 = [-0.4;0.65];
c7 = [0.15;0.4];
c8 = [0.25;0];
c9 = [0.05;0.15];
c10= [0.35;0.05];

SA03 = R - c0;   % A B D E F G H J K M N O R             
SB03 = R - c3; 

SA08 = H - c0;
SB08 = H - c8; 


SA010 = N - c0;
SB010 = N - c10;

SA34 = O - c3;
SB34 = O - c4;

SA46 = D - c4;
SB46 = D - c6;

SA37 = G - c3;
SB37 = G - c7;

SA12 = B - c1;
SB12 = B - c2;

SA14 = A - c1;
SB14 = A - c4;

SA49 = M - c4;
SB49 = M - c9;

SA26 = E - c2;
SB26 = E - c6;

SA35 = F - c3;
SB35 = F - c5;

SA25 = J - c2;
SB25 = J - c5;

SA78 = G - c7;
SB78 = G - c8;

SA910 = M - c9;
SB910 = M - c10;

%q= zeros(30,1);
 dq = zeros(30,1);

 d2q = zeros(30,1);

counter = 0; 

dt = 0.05; % Time step

% Kinematics at time t
for t = 0:dt:5
    % Position problem. 
    % Initial approximation = previous solution + estimated changes due to velocity and acceleration, 
   
    q0 = q + dq * dt + 0.5 * d2q * dt^2;
   
    q = Newton_Raphson(q0,t); 
    
    dq = Velocity(q,t);  % Velocity problem

    d2q = Acceleration(dq,q,t);  % Acceleration problem
    
    % Saving the results 
    counter = counter+1;
    T(1,counter) = t; 
    Q(:,counter) = q;
    DQ(:,counter) = dq;
    D2Q(:,counter) = d2q;
    
%     % Detecting the singularity
    Fq=Jacobian(q);
    if(rank(Fq)~=length(q))
        error('Warning: Singularity detected')
    end
    size(q)
    size(Fq)
    rank1=rank(Fq)
    
end

%Plot Point R
figure(1)
length(T)
pos = [];                    % A  B D E F G H J K M N O R      
vel = [];
for i=1:length(T)
    pos(:,i) = Q(7:8,i) + Rot(Q(9,i))*SB03;
    vel(:,i) = DQ(7:8,i) + Om*Rot(Q(9,i))*SB03*DQ(9,i);
    acc(:,i) = D2Q(7:8,i) + Om*Rot(Q(9,i))*SB03*D2Q(9,i) - Rot(Q(9,i))*SB03*(DQ(9,i)^2);
end
figure(1)
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')

%Plot Point H
figure(2)
for i=1:length(T)
    pos(:,i) = Q(22:23,i) + Rot(Q(24,i))*SB08;
    vel(:,i) = DQ(22:23,i) + Om*Rot(Q(24,i))*SB08*DQ(24,i);
    acc(:,i) = D2Q(22:23,i) + Om*Rot(Q(24,i))*SB08*D2Q(24,i) - Rot(Q(24,i))*SB08*(DQ(24,i)^2);
end
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')
%Plot Point N

for i=1:length(T)
    pos(:,i) = Q(28:29,i) + Rot(Q(30,i))*SB010;
    vel(:,i) = DQ(28:29,i) + Om*Rot(Q(30,i))*SB010*DQ(30,i);
    acc(:,i) = D2Q(28:29,i) + Om*Rot(Q(30,i))*SB010*D2Q(30,i) - Rot(Q(30,i))*SB010*(DQ(30,i)^2);
end

figure (3)
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')
%Plot Point O
for i=1:length(T)
    pos(:,i) = Q(10:11,i) + Rot(Q(12,i))*SB34;
    vel(:,i) = DQ(10:11,i) + Om*Rot(Q(12,i))*SB34*DQ(12,i);
    acc(:,i) = D2Q(10:11,i) + Om*Rot(Q(12,i))*SB34*D2Q(12,i) - Rot(Q(12,i))*SB34*(DQ(12,i)^2);
end

figure (4)
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')

%Plot Point D
for i=1:length(T)
    pos(:,i) = Q(10:11,i) + Rot(Q(12,i))*SA46;
    vel(:,i) = DQ(10:11,i) + Om*Rot(Q(12,i))*SA46*DQ(12,i);
    acc(:,i) = D2Q(10:11,i) + Om*Rot(Q(12,i))*SA46*D2Q(12,i) - Rot(Q(12,i))*SA46*(DQ(12,i)^2);
end

figure (5)
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')

%Plot Point G
for i=1:length(T)
    pos(:,i) = Q(7:8,i) + Rot(Q(9,i))*SA37;
    vel(:,i) = DQ(7:8,i) + Om*Rot(Q(9,i))*SA37*DQ(9,i);
    acc(:,i) = D2Q(7:8,i) + Om*Rot(Q(9,i))*SA37*D2Q(9,i) - Rot(Q(9,i))*SA37*(DQ(9,i)^2);
end

figure (6)
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')
%Plot Point B
for i=1:length(T)
    pos(:,i) = Q(1:2,i) + Rot(Q(3,i))*SA12;
    vel(:,i) = DQ(1:2,i) + Om*Rot(Q(3,i))*SA12*DQ(3,i);
    acc(:,i) = D2Q(1:2,i) + Om*Rot(Q(3,i))*SA12*D2Q(3,i) - Rot(Q(3,i))*SA12*(DQ(3,i)^2);
end

figure (7)
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')

%Plot Point A
for i=1:length(T)
    pos(:,i) = Q(1:2,i) + Rot(Q(3,i))*SA14;
    vel(:,i) = DQ(1:2,i) + Om*Rot(Q(3,i))*SA14*DQ(3,i);
    acc(:,i) = D2Q(1:2,i) + Om*Rot(Q(3,i))*SA14*D2Q(3,i) - Rot(Q(3,i))*SA14*(DQ(3,i)^2);
end

figure (8)
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')
%Plot Point M
for i=1:length(T)
    pos(:,i) = Q(10:11,i) + Rot(Q(12,i))*SA49;
    vel(:,i) = DQ(10:11,i) + Om*Rot(Q(12,i))*SA49*DQ(12,i);
    acc(:,i) = D2Q(10:11,i) + Om*Rot(Q(12,i))*SA49*D2Q(12,i) - Rot(Q(12,i))*SA49*(DQ(12,i)^2);
end

figure (9)
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')

%Plot Point E
for i=1:length(T)
    pos(:,i) = Q(4:5,i) + Rot(Q(6,i))*SA26;
    vel(:,i) = DQ(4:5,i) + Om*Rot(Q(6,i))*SA26*DQ(6,i);
    acc(:,i) = D2Q(4:5,i) + Om*Rot(Q(6,i))*SA26*D2Q(6,i) - Rot(Q(6,i))*SA26*(DQ(6,i)^2);
end

figure (10)
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')

%Plot Point F
for i=1:length(T)
    pos(:,i) = Q(7:8,i) + Rot(Q(9,i))*SA35;
    vel(:,i) = DQ(7:8,i) + Om*Rot(Q(9,i))*SA35*DQ(9,i);
    acc(:,i) = D2Q(7:8,i) + Om*Rot(Q(9,i))*SA35*D2Q(9,i) - Rot(Q(9,i))*SA35*(DQ(9,i)^2);
end

figure (11)
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')

%Plot Point E
for i=1:length(T)
    pos(:,i) = Q(4:5,i) + Rot(Q(6,i))*SA25;
    vel(:,i) = DQ(4:5,i) + Om*Rot(Q(6,i))*SA25*DQ(6,i);
    acc(:,i) = D2Q(4:5,i) + Om*Rot(Q(6,i))*SA25*D2Q(6,i) - Rot(Q(6,i))*SA25*(DQ(6,i)^2);
end

figure (12)
subplot(3,2,1)
plot(T,pos(1,:),'b-')
title('Position in X axis for D%d')

subplot(3,2,2)
plot(T,pos(2,:),'b-')
title('Position in Y axis for ')

subplot(3,2,3)
plot(T,vel(1,:),'b-')
title('Velocity in X axis for ')

subplot(3,2,4)
plot(T,vel(2,:),'b-')
title('Velocity in y axis for ')

subplot(3,2,5)
plot(T,acc(1,:),'b-')
title('Acceleration in X axis for ')

subplot(3,2,6)
plot(T,acc(2,:),'b-')
title('Acceleration in y axis for ')

