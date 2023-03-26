function [R, t] = estimateTransform(points_in, points_out)
% estimate rotation matrix R and translation vector T such that
% p1 * R + t = p2 (if possible)
% size(p1) = M x 3
if ~isequal(size(points_in), size(points_out))
    error('Points matrices have different sizes');
end
if size(points_in, 2) ~= 3
    if size(points_in, 1) == 3
        points_in = points_in';
        points_out = points_out';
    else
        error('Points matrices must have either three rows or three columns');
    end
end
% Find centroid and deviations from centroid
c1 = mean(points_in);
c2 = mean(points_out);

p1n = points_in-c1;
p2n = points_out-c2;

% Covariance matrix
H = p1n'*p2n;

% Solve equations using SVD
[U,~,V] = svd(H);

% Handle the reflection case
R = V*diag([ones(1,size(points_in,2)-1) sign(det(U*V'))])*U';

% Compute the translation
t = c2' - R*c1';
R = R';
t = t';
end