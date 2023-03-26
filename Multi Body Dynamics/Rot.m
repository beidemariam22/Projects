function R=Rot(fi)
% R=Rot(fi)
%   Rotation matrix (2x2)
% In:
%   fi - the angle (rad).
% Out:
%   R - the matrix.
%

R=[cos(fi) -sin(fi);
    sin(fi) cos(fi)];