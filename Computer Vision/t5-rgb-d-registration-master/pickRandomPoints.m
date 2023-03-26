function [p1, p2] = pickRandomPoints(N, pts1, pts2)
% PICKRANDOMPOINTS Pick N random point pairs from the given sets
%
% Inputs:
%   cnt  : number of pairs to return
%   pts1 : first set of points (Nx3)
%   pts2 : second set of points (Nx3)
%
% Outputs:
%   p1   : first subset of points (cnt x 3)
%   p2   : second subset of points (cnt x 3)
p1 = zeros([N 3]); p2 = zeros([N 3]);
indxs = randi(size(pts1,1),1,N);
for p=1:3
    p1(p,:) = pts1(indxs(p),:); p2(p,:) = pts2(indxs(p),:);
end
end