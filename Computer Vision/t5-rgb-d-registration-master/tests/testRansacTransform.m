function testRansacTransform()
    p1 = [4 5 6; 8 9 4; 5 7 3];
    theta = 85;
    disp('Original transform')
    R_ = [ cosd(theta) sind(theta) 0; ...
        -sind(theta) cosd(theta) 0; ...
        0 0 1]
    t_ = [2 3 4]
    p2 = p1*R_ + t_;
    % Add wrong point correspondences
    p1 = [p1; 4 4 4];
    p2 = [p2; 4 4 4];
    disp('Recomposed transform')
    % Only one combination of points should give this
    iter = 100; ratio = 0.75; thr = 1e-3;
    [R, t] = ransacTransform(p1, p2, iter, ratio, thr)
    p3 = p1*R+t;
    
    figure()
    title('Original')
    scatter3(p1(:,1), p1(:,2), p1(:,3),50,'m');
    hold on
    scatter3(p2(:,1), p2(:,2), p2(:,3),20,'g');
    hold off

    figure()
    title('Transformed magenta')
    scatter3(p3(:,1), p3(:,2), p3(:,3),50,'m');
    hold on
    scatter3(p2(:,1), p2(:,2), p2(:,3),20,'g');
    hold off