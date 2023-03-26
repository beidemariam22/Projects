function d2q = Acceleration(dq,q,t)
%   This procedure solves the acceleration problem.
%   The position and velocity problems have to be solved earlier.
% In:
%   dq - the vector of time derivatives of absolute coordinates,
%   q - the vector of absolute coordinates,
%   t - the current time instant.
% Out:
%   d2q - the vector of the second time derivatives of absolute coordinates.

Om = [0 -1;
      1  0];  % Auxiliary matrix
  
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

% Translational joint 7-8, GH
%f78=0; 
da1 = G-H;
da1_mag = norm(G-H); 
u78 = da1/da1_mag;
v78 = Om*u78;

% Translational joint 9-10, M
%f910=0;
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

% More user-friendly names
dfi1 = dq(3);
dfi2 = dq(6);
dfi3 = dq(9);
dfi4 = dq(12);
dfi5 = dq(15);
dfi6 = dq(18);
dfi7 = dq(21);
dfi8 = dq(24);  
dfi9 = dq(27);
dfi10 = dq(30);

% More user-friendly names
dr1 = dq(1:2);
dr2 = dq(4:5);
dr3 = dq(7:8);
dr4 = dq(10:11);
dr5 = dq(13:14);
dr6 = dq(16:17);
dr7 = dq(19:20);
dr8 = dq(22:23);
dr9 = dq(25:26);
dr10 = dq(28:29);

gam = zeros(30,1);
% Right hand side of the linear equations set        

% Revolute joint 0-3, R
gam(1:2,1) = -Rot3*SB03*dfi3^2;

% Revolute joint 0-8, H
gam(3:4,1) = -Rot8*SB08*dfi8^2;

% Revolute joint 0-10, N
gam(5:6,1) = -Rot10*SB010*dfi10^2;    

% Revolute joint 3-4, O
gam(7:8,1) = Rot3*SA34*dfi3^2 - Rot4*SB34*dfi4^2;

% Revolute joint 4-6, D
gam(9:10,1) =  Rot4*SA46*dfi4^2 - Rot6*SB46*dfi6^2;

% Revolute joint 3-7, G
gam(11:12,1) = Rot3*SA37*dfi3^2 - Rot7*SB37*dfi7^2;

% Revolute joint 1-2, B
gam(13:14,1) = Rot1*SA12*dfi1^2 - Rot2*SB12*dfi2^2;

% Revolute joint 1-4, A
gam(15:16,1) = Rot1*SA14*dfi1^2 - Rot4*SB14*dfi4^2;

% Revolute joint 4-9, M
gam(17:18,1) = Rot4*SA49*dfi4^2 - Rot9*SB49*dfi9^2;   

% Revolute joint 2-6, E
gam(19:20,1) = Rot2*SA26*dfi2^2 - Rot6*SB26*dfi6^2;

% Revolute joint 3-5, F
gam(21:22,1) = Rot3*SA35*dfi3^2 - Rot5*SB35*dfi5^2;

% Revolute joint 2-5, J
gam(23:24,1) = Rot2*SA25*dfi2^2 - Rot5*SB25*dfi5^2;

% Translational joints 7-8, GH
gam(25,1) = 0;
gam(26,1) = (Rot8*v78)'*(2*Om*(dr8-dr7)*dfi8+(r8-r7)*dfi8^2 - Rot7*SA78*(dfi8-dfi7)^2);

% Translational joints 9-10, MN
gam(27,1) = 0;
gam(28,1) = (Rot10*v910)'*(2*Om*(dr10-dr9)*dfi10+(r10-r9)*dfi10^2 - Rot9*SA910*(dfi10-dfi9)^2);

% Driving constraints 7-8, GH
gam(29,1) = (Rot7*u78)'*(2*Om*(dr8-dr7)*dfi7+(r8-r7)*dfi7^2 - Rot8*SB78*(dfi8-dfi7)^2) + (0.225 * sin(1.5*t));

% Driving constraints 9-10, MN
gam(30,1) = (Rot9*u910)'*(2*Om*(dr10-dr9)*dfi9+(r10-r9)*dfi9^2 - Rot10*SB910*(dfi10-dfi9)^2) - (0.225 * sin(1.5*t));

% Coefficient matrix
Fq = Jacobian(q);

% Solution
d2q = Fq\gam; 