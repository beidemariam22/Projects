function H = calculate_homography(points_in, points_out)
% CALCULATE_HOMOGRAPHY finds a homography from point pairs
%   H = CALCULATE_HOMOGRAPHY(points_in, points_out) takes a 2xN matrix of input
%   vectors and a 2xN matrix of output vectors, and returns the homogeneous
%   transformation matrix that maps the inputs to the outputs, to some
%   approximation if there is noise.
if ~isequal(size(points_in), size(points_out))
    error('Points matrices different sizes');
end
if size(points_in, 1) ~= 2
    if size(points_in, 2) == 2
        points_in = points_in';
        points_out = points_out';
    else
        error('Points matrices must have either two rows or two columns');
    end
end
n = size(points_in, 2);
if n < 4
    error('Need at least 4 matching points');
end
% Solve equations using SVD
x = points_out(1, :);
y = points_out(2,:);
X = points_in(1,:);
Y = points_in(2,:);
rows0 = zeros(3, n);
rowsXY = -[X; Y; ones(1,n)];
hx = [rowsXY; rows0; x.*X; x.*Y; x];
hy = [rows0; rowsXY; y.*X; y.*Y; y];
h = [hx hy];
if n == 4
    [U, ~, ~] = svd(h);
else
    [U, ~, ~] = svd(h, 'econ');
end
H = (reshape(U(:,9), 3, 3)).';
end