function [Acc,T,Q,DQ,D2Q] = main()
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


% q=[-1.2;0.6;deg2rad(173.125676721);
%    -0.7;0.85;deg2rad(265.8372382231);
%    0.4;0.65;deg2rad(302.8099170133);
%    -0.35;0.4;deg2rad(275.006592928);
%    0.1;0.9;deg2rad(270.0);
%    -0.4;0.65;deg2rad(180.0);
%    0.15;0.4;deg2rad(194.0362434679);
%    0.25;0;deg2rad(194.0362434679);
%    0.05;0.15;deg2rad(251.5650511771);
%    0.35;0.05; deg2rad(251.5650511771)];

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
%     if(rank(Fq)~=length(q))
%         error('Warning: Singularity detected')
%     end
    size(q)
    size(Fq)
    rank1=rank(Fq)
    
end

% Plot point c1
% Position x
figure(1)
subplot(3,2,1)
plot(T,Q(1,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,1),'b--', 'LineWidth',2)
title('Position in X axis')
legend('Matlab', 'ADAMS')

% Position y
subplot(3,2,2)
plot(T,Q(2,:),'g', 'LineWidth',2)
hold on 
plot(T,Data(:,2),'b--', 'LineWidth',2)
title('Position in Y axis')
legend('Matlab', 'ADAMS')

% Velocity x
subplot(3,2,3)
plot(T,DQ(1,:),'g', 'LineWidth',2)
hold on 
plot(T,Data(:,3),'b--', 'LineWidth',2)
title('Velocity in X axis')
legend('Matlab', 'ADAMS')

% Velocity y
subplot(3,2,4)
plot(T,DQ(2,:),'g', 'LineWidth',2)
hold on 
plot(T,Data(:,4),'b--', 'LineWidth',2)
title('Velocity in Y axis')
legend('Matlab', 'ADAMS')

% Acceleration x
subplot(3,2,5)
plot(T,D2Q(1,:),'g', 'LineWidth',2)
hold on 
plot(T,Data(:,5),'b--', 'LineWidth',2)
title('Accleration in X axis')
legend('Matlab', 'ADAMS')

% Acceleration y
subplot(3,2,6)
plot(T,D2Q(2,:),'g', 'LineWidth', 2)
hold on 
plot(T,Data(:,6),'b--', 'LineWidth',2)
title('Accleration in Y axis')
legend('Matlab', 'ADAMS')

% Plot point c2
% Position
figure(2)
subplot(3,2,1)
plot(T,Q(4,:),'g', 'LineWidth',2)
hold on 
plot(T,Data(:,7),'b--', 'LineWidth',2)
title('Position in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,2)
plot(T,Q(5,:),'g', 'LineWidth',2)
hold on 
plot(T,Data(:,8),'b--', 'LineWidth',2)
title('Position in Y axis')
legend('Matlab', 'ADAMS')

% Velocity
subplot(3,2,3)
plot(T,DQ(4,:),'g', 'LineWidth',2)
hold on 
plot(T,Data(:,9),'b--', 'LineWidth',2)
title('Velocity in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,4)
plot(T,DQ(5,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,10),'b--', 'LineWidth',2)
title('Velocity in Y axis')
legend('Matlab', 'ADAMS')

% Acceleration
subplot(3,2,5)
plot(T,D2Q(4,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,11),'b--', 'LineWidth',2)
title('Accleration in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,6)
plot(T,D2Q(5,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,12),'b--', 'LineWidth',2)
title('Accleration in Y axis')
legend('Matlab', 'ADAMS')

% Plot point c3
% Position
figure(3)
subplot(3,2,1)
plot(T,Q(7,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,13),'b--', 'LineWidth',2')
title('Position in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,2)
plot(T,Q(8,:),'g', 'LineWidth',2)
hold on 
plot(T,Data(:,14),'b--', 'LineWidth',2)
title('Position in Y axis')
legend('Matlab', 'ADAMS')

% Velocity
subplot(3,2,3)
plot(T,DQ(7,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,15),'b--', 'LineWidth',2)
title('Velocity in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,4)
plot(T,DQ(8,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,16),'b--', 'LineWidth',2)
title('Velocity in Y axis')
legend('Matlab', 'ADAMS')

% Acceleration
subplot(3,2,5)
plot(T,D2Q(7,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,17),'b--', 'LineWidth',2)
title('Accleration in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,6)
plot(T,D2Q(8,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,18),'b--', 'LineWidth',2)
title('Accleration in Y axis')
legend('Matlab', 'ADAMS')

% Plot point c4
% Position
figure(4)
subplot(3,2,1)
plot(T,Q(10,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,19),'b--', 'LineWidth',2)
title('Position in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,2)
plot(T,Q(11,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,20),'b--', 'LineWidth',2)
title('Position in Y axis')
legend('Matlab', 'ADAMS')

% Velocity
subplot(3,2,3)
plot(T,DQ(10,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,21),'b--', 'LineWidth',2)
title('Velocity in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,4)
plot(T,DQ(11,:),'g', 'LineWidth',2)
hold on 
plot(T,Data(:,22),'b--', 'LineWidth',2)
title('Velocity in Y axis')
legend('Matlab', 'ADAMS')

% Acceleration
subplot(3,2,5)
plot(T,D2Q(10,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,23),'b--', 'LineWidth',2)
title('Accleration in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,6)
plot(T,D2Q(11,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,24),'b--', 'LineWidth',2)
title('Accleration in Y axis')
legend('Matlab', 'ADAMS')

% Plot point c5
% Position
figure(5)
subplot(3,2,1)
plot(T,Q(13,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,25),'b--', 'LineWidth',2)
title('Position in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,2)
plot(T,Q(14,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,26),'b--', 'LineWidth',2)
title('Position in Y axis')
legend('Matlab', 'ADAMS')

% Velocity
subplot(3,2,3)
plot(T,DQ(13,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,27),'b--', 'LineWidth',2)
title('Velocity in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,4)
plot(T,DQ(14,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,28),'b--', 'LineWidth',2)
title('Velocity in Y axis')
legend('Matlab', 'ADAMS')

% Acceleration
subplot(3,2,5)
plot(T,D2Q(13,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,29),'b--', 'LineWidth',2)
title('Accleration in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,6)
plot(T,D2Q(14,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,30),'b--', 'LineWidth',2)
title('Accleration in Y axis')
legend('Matlab', 'ADAMS')

% Plot point c6
% Position
figure(6)
subplot(3,2,1)
plot(T,Q(16,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,31),'b--', 'LineWidth',2)
title('Position in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,2)
plot(T,Q(17,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,32),'b--', 'LineWidth',2)
title('Position in Y axis')
legend('Matlab', 'ADAMS')

% Velocity
subplot(3,2,3)
plot(T,DQ(16,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,33),'b--', 'LineWidth',2)
title('Velocity in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,4)
plot(T,DQ(17,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,34),'b--', 'LineWidth',2)
title('Velocity in Y axis')
legend('Matlab', 'ADAMS')

% Acceleration
subplot(3,2,5)
plot(T,D2Q(16,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,35),'b--', 'LineWidth',2)
title('Accleration in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,6)
plot(T,D2Q(17,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,36),'b--', 'LineWidth',2)
title('Accleration in Y axis')
legend('Matlab', 'ADAMS')

% Plot point c7
% Position
figure(7)
subplot(3,2,1)
plot(T,Q(19,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,37),'b--', 'LineWidth',2)
title('Position in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,2)
plot(T,Q(20,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,38),'b--', 'LineWidth',2)
title('Position in Y axis')
legend('Matlab', 'ADAMS')

% Velocity
subplot(3,2,3)
plot(T,DQ(19,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,39),'b--', 'LineWidth',2)
title('Velocity in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,4)
plot(T,DQ(20,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,40),'b--', 'LineWidth',2)
title('Velocity in Y axis')
legend('Matlab', 'ADAMS')

% Acceleration
subplot(3,2,5)
plot(T,D2Q(19,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,41),'b--', 'LineWidth',2)
title('Accleration in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,6)
plot(T,D2Q(20,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,42),'b--', 'LineWidth',2)
title('Accleration in Y axis')
legend('Matlab', 'ADAMS')

% Plot point c8
% Position
figure(8)
subplot(3,2,1)
plot(T,Q(22,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,43),'b--', 'LineWidth',2)
title('Position in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,2)
plot(T,Q(23,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,44),'b--', 'LineWidth',2)
title('Position in Y axis')
legend('Matlab', 'ADAMS')

% Velocity
subplot(3,2,3)
plot(T,DQ(22,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,45),'b--', 'LineWidth',2)
title('Velocity in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,4)
plot(T,DQ(23,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,46),'b--', 'LineWidth',2)
title('Velocity in Y axis')
legend('Matlab', 'ADAMS')

% Acceleration
subplot(3,2,5)
plot(T,D2Q(22,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,47),'b--', 'LineWidth',2)
title('Accleration in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,6)
plot(T,D2Q(23,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,48),'b--', 'LineWidth',2)
title('Accleration in Y axis')
legend('Matlab', 'ADAMS')

% Plot point c9
% Position
figure(9)
subplot(3,2,1)
plot(T,Q(25,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,49),'b--', 'LineWidth',2)
title('Position in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,2)
plot(T,Q(26,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,50),'b--', 'LineWidth',2)
title('Position in Y axis')
legend('Matlab', 'ADAMS')

% Velocity
subplot(3,2,3)
plot(T,DQ(25,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,51),'b--', 'LineWidth',2)
title('Velocity in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,4)
plot(T,DQ(26,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,52),'b--', 'LineWidth',2)
title('Velocity in Y axis')
legend('Matlab', 'ADAMS')

% Acceleration
subplot(3,2,5)
plot(T,D2Q(25,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,53),'b--', 'LineWidth',2)
title('Accleration in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,6)
plot(T,D2Q(26,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,54),'b--', 'LineWidth',2)
title('Accleration in Y axis')
legend('Matlab', 'ADAMS')

% Plot point c10
% Position
figure(10)
subplot(3,2,1)
plot(T,Q(28,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,55),'b--', 'LineWidth',2)
title('Position in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,2)
plot(T,Q(29,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,56),'b--', 'LineWidth',2)
title('Position in Y axis')
legend('Matlab', 'ADAMS')

% Velocity
subplot(3,2,3)
plot(T,DQ(28,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,57),'b--', 'LineWidth',2)
title('Velocity in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,4)
plot(T,DQ(29,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,58),'b--', 'LineWidth',2)
title('Velocity in Y axis')
legend('Matlab', 'ADAMS')

% Acceleration
subplot(3,2,5)
plot(T,D2Q(28,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,59),'b--', 'LineWidth',2)
title('Accleration in X axis')
legend('Matlab', 'ADAMS')

subplot(3,2,6)
plot(T,D2Q(29,:),'g', 'LineWidth',2)
hold on
plot(T,Data(:,60),'b--', 'LineWidth',2)
title('Accleration in Y axis')
legend('Matlab', 'ADAMS')

% RSME
format short e
for i=1:10
    Acc(i,:) = RMSE(i, Q, DQ, D2Q,Data);
end
%Plot Point D
figure(9)
length(T)

pos = [];
vel = [];

for i=1:length(T)
    pos(:,i) = Q(10:11,i) + Rot(Q(12,i))*SA46;
    vel(:,i) = DQ(10:11,i) + Om*Rot(Q(12,i))*SA46*DQ(12,i);
    acc(:,i) = D2Q(10:11,i) + Om*Rot(Q(12,i))*SA46*D2Q(12,i) - Rot(Q(12,i))*SA46*(DQ(12,i)^2);
end
figure(11)
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









