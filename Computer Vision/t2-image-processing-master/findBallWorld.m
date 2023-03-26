function result = findBallWorld(im, cameraParams)
% Ball is 20 cm radius = 200 mm
result = findBall(im);
persistent cameraParams_
if isempty(cameraParams_)
    if ~exist('cameraParams', 'var')
        [cameraParams_, ~] = calibrate_camera();
    else
        cameraParams_ = cameraParams;
    end
end
if ~isempty(result.ball)
    result.ball.WorldRadius = 200; % mm
    f = cameraParams_.Intrinsics.FocalLength;
    c = cameraParams_.Intrinsics.PrincipalPoint;
    Zw = f(1)*result.ball.WorldRadius/result.ball.Radius;
    result.ball.WorldCentroid = Zw*[(result.ball.Centroid-c)./f 1];
end