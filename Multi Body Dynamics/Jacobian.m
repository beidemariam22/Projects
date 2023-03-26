function Fq = Jacobian(q)
%   This procedure cooperates with NewtonRaphson.
%   The constraint Jacobian is calculated.
% In:
%   q - the vector of absolute coordinates
% Out:
%   Fq - the constraint Jacobian.


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

% Constraint Jacobian - initially contains only zeros
Fq = zeros(30,30);

% Constraint Jacobian - setting non-zero entries


% Revolute joint 0-3, R
Fq(1:2,7:8) = -eye(2);
Fq(1:2,9) = -Om*Rot3*SB03;

% Revolute joint 0-8, H
Fq(3:4,22:23) = -eye(2);
Fq(3:4,24) = -Om*Rot8*SB08;

% Revolute joint 0-10, N
Fq(5:6,28:29) = -eye(2);
Fq(5:6,30) = -Om*Rot10*SB010;


% Revolute joint 3-4, O
Fq(7:8,7:8) = eye(2);
Fq(7:8,9) = Om*Rot3*SA34;
Fq(7:8,10:11) = -eye(2);
Fq(7:8,12) = -Om*Rot4*SB34;

% Revolute joint 4-6, D
Fq(9:10,10:11) = eye(2);
Fq(9:10,12) = Om*Rot4*SA46;
Fq(9:10,16:17) = -eye(2);
Fq(9:10,18) = -Om*Rot6*SB46;

% Revolute joint 3-7, G
Fq(11:12,7:8) = eye(2);
Fq(11:12,9) = Om*Rot3*SA37;
Fq(11:12,19:20) = -eye(2);
Fq(11:12,21) = -Om*Rot7*SB37;

% Revolute joint 1-2, B
Fq(13:14,1:2) = eye(2);
Fq(13:14,3) = Om*Rot1*SA12;
Fq(13:14,4:5) = -eye(2);
Fq(13:14,6) = -Om*Rot2*SB12;

% Revolute joint 1-4, A
Fq(15:16,1:2) = eye(2);
Fq(15:16,3) = Om*Rot1*SA14;
Fq(15:16,10:11) = -eye(2);
Fq(15:16,12) = -Om*Rot4*SB14;

% Revolute joint 4-9, M
Fq(17:18,10:11) = eye(2);
Fq(17:18,12) = Om*Rot4*SA49;
Fq(17:18,25:26) = -eye(2);
Fq(17:18,27) = -Om*Rot9*SB49;

% Revolute joint 2-6, E
Fq(19:20,4:5) = eye(2);
Fq(19:20,6) = Om*Rot2*SA26;
Fq(19:20,16:17) = -eye(2);
Fq(19:20,18) = -Om*Rot6*SB26;

% Revolute joint 3-5, F
Fq(21:22,7:8) = eye(2);
Fq(21:22,9) = Om*Rot3*SA35;
Fq(21:22,13:14) = -eye(2);
Fq(21:22,15) = -Om*Rot5*SB35;

% Revolute joint 2-5, J
Fq(23:24,4:5) = eye(2);
Fq(23:24,6) = Om*Rot2*SA25;
Fq(23:24,13:14) = -eye(2);
Fq(23:24,15) = -Om*Rot5*SB25;

% Translational joint 7-8 GH
%fi k angle
Fq(25,21) = 1;
Fq(25,24) = -1;

%fi k Arrow
Fq(26,19:20) = (-Rot8*v78)';
Fq(26,21) = -(Rot8*v78)'*Om*Rot7*SA78;
Fq(26,22:23) = (Rot8*v78)';
Fq(26,24) = -(Rot8*v78)'*Om*(r8-r7-Rot7*SA78);

% Translational joint 9-10  MN
Fq(27,27) = 1; 
Fq(27,30) = -1; 

 
Fq(28,25:26) = (-Rot10*v910)';
Fq(28,27) = -(Rot10*v910)'*Om*Rot9*SA910;
Fq(28,28:29) = (Rot10*v910)';
Fq(28,30) = -(Rot10*v910)'*Om*(r10-r9-Rot9*SA910);


% Driving constraint 1      GH
Fq(29,19:20) = -(Rot8*u78)';
Fq(29,21) = -(Rot8*u78)'*Om*Rot7*SA78;
Fq(29,22:23)= (Rot8*u78)';
Fq(29,24) = -(Rot8*u78)'*Om*(r8-r7-Rot7*SA78);

% Driving constraint 2      MN
Fq(30,25:26) = -(Rot10*u910)';
Fq(30,27) = -(Rot10*u910)'*Om*Rot9*SA910;
Fq(30,28:29) = (Rot10*u910)';
Fq(30,30) = -(Rot10*u910)'*Om*(r10-r9-Rot9*SA910);
