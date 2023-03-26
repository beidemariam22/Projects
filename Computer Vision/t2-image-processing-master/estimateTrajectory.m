function trajectory = estimateTrajectory(ball)
% "ball" is a Nx4 matrix where every row contains [X, Y, Z, t]
% being X, Y and Z the 3D coordinates of the ball and "t" the time step
% since the initial time. "trajectory" is a 1x3 vector with the 
% polynomial coefficients
warning('off', 'stats:statrobustfit:IterationLimit');
trajectory = zeros(3);
for k=1:3
    v = flip(robustfit([ball(:, 4) ball(:, 4).^2], ball(:,k))');
    trajectory(k, :) = v;
end
