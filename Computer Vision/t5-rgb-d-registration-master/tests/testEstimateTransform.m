function testEstimateTransform()
    p1 = [4 5 6; 8 9 4; 5 7 3];
    theta = 85;
    disp('Original transform')
    R_ = [ cosd(theta) sind(theta) 0; ...
        -sind(theta) cosd(theta) 0; ...
        0 0 1]
    t_ = [2 3 4]
    p2 = p1*R_ + t_;
    disp('Recomposed transform')
    [R, t] = estimateTransform(p1, p2)