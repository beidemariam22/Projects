function F = Constraints(q,t)
%   This procedure cooperates with NewtonRaphson.
%   Left hand side of constraint equations is calculated.
% In:
%   q - the vector of absolute coordinates,
%   t - the current time instant.
% Out:
%   F - the calculated vector.

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
%  t = 0;

Om = [0 -1;
      1  0];  % Auxiliary matrix

% Translational joint 7-8, DA
da1 = G-H;
da1_mag = norm(G-H); 
u78 = da1/da1_mag;
v78 = Om*u78;

% Translational joint 9-10, HB

da2 = M-N;
da2_mag = norm(M-N); 
u910 = da2/da2_mag;
v910 = Om*u910;

% User-friendly names
r1 = q(1:2);   fi1 = q(3);
r2 = q(4:5);   fi2 = q(6);
r3 = q(7:8);   fi3 = q(9);
r4 = q(10:11); fi4 = q(12);
r5 = q(13:14); fi5 = q(15);
r6 = q(16:17); fi6 = q(18);
r7 = q(19:20); fi7 = q(21);
r8 = q(22:23); fi8 = q(24);
r9 = q(25:26); fi9 = q(27);
r10= q(28:29); fi10 = q(30);


% Rotation matrices
Rot1 = Rot(fi1);
Rot2 = Rot(fi2);
Rot3 = Rot(fi3);
Rot4 = Rot(fi4);
Rot5 = Rot(fi5);
Rot6 = Rot(fi6);
Rot7 = Rot(fi7);
Rot8 = Rot(fi8);
Rot9 = Rot(fi9);
Rot10 = Rot(fi10);

% Constraint equations (left hand side)
% Revolute joints

F(1:2,1) = SA03 - (r3+Rot3*SB03);                   %R
F(3:4,1) = SA08 - (r8+Rot8*SB08);                   %H
F(5:6,1) = SA010 - (r10+Rot10*SB010);               %N
F(7:8,1) = r3+Rot3*SA34 - (r4+Rot4*SB34);           %O
F(9:10,1) = r4+Rot4*SA46 - (r6+Rot6*SB46);          %D
F(11:12,1) = r3+Rot3*SA37 - (r7+Rot7*SB37);         %G
F(13:14,1) = r1+Rot1*SA12 - (r2+Rot2*SB12);         %B
F(15:16,1) = r1+Rot1*SA14 - (r4+Rot4*SB14);         %A
F(17:18,1) = r4+Rot4*SA49 - (r9+Rot9*SB49);         %M
F(19:20,1) = r2+Rot2*SA26 - (r6+Rot6*SB26);         %E
F(21:22,1) = r3+Rot3*SA35 - (r5+Rot5*SB35);         %F     
F(23:24,1) = r2+Rot2*SA25 - (r5+Rot5*SB25);         %J

% Translational joints 7-8; 9-10

F(25,1) = (fi8-fi7); 
F(26,1) = (Rot8*v78)'*((r8-Rot8*SB78)-(r7+Rot7*SA78));

F(27,1) = (fi10-fi9);
F(28,1) = (Rot10*v910)'*((r10-Rot10*SB910)-(r9+Rot9*SA910)); 

% Driving constraints 
f1 =  -0.1*sin(1.5*t+0);    % motion
f2 =  0.1*sin(1.5*t+0); % motion
dc7c8 = 0.4123; % distance between G and H
dc9c10 = 0.3162; % distaance between M and N
    
 F(29,1) = (Rot8*u78)'*(r8+Rot8*SB78 - (r7+Rot7*SA78))-f1;
 F(30,1) = (Rot10*u910)'*(r10+Rot10*SB910 - (r9+Rot9*SA910))-f2;
 
