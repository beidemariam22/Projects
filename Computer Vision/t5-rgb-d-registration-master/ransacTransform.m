function [R, t] = ransacTransform(pts1, pts2, iter, ratio, thr)
% RANSACTRANSFORM Estimate the best transform R, T between the two given 
% point sets, such that pts1 * R + T are as close to pts2 as possible
%
% Inputs:
%   pts1 : first set of points, of size Nx3
%   pts2 : second set of points, of size Nx3
%   iter : maximum number of RanSaC iterations
%   ratio: inliers ratio for the transformation to be treated as good [0..1]
%   thr  : threshold between the points to be treated as the inlier (in meters)
pnum = size(pts1,1);
for k=1:iter
    % Randomly select 3 correspondences
    [points_in, points_out] = pickRandomPoints(3, pts1, pts2);
    % Compute transformation
    [R, t] = estimateTransform(points_in, points_out);
    % Compute the number of inliners
    diff_ = pts2 - (pts1*R + t);
    dist_ = sqrt(sum(diff_.^2,2));
    inliners = sum(dist_ <= thr, 'all');
    % If number of inliers matches the ratio, break
    ratio_ = inliners/pnum;
    if (ratio_ >= ratio)
        break;
    end
end
fprintf('Finished ransac in %d iterations with a median distance of %d and %d%% inliners\n', k, median(dist_), round(ratio_*100))
end