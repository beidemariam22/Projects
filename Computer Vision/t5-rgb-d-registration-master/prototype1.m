% Read the two images.
img1 = imread('ecovi_t5/rgb/0.png');
I1 = rgb2gray(img1);
img2 = imread('ecovi_t5/rgb/50.png');
I2 = rgb2gray(img2);

% Find the SURF features. MetricThreshold controls the number of detected
% points. To get more points make the threshold lower.
points1 = detectSURFFeatures(I1, 'MetricThreshold', 200);
points2 = detectSURFFeatures(I2, 'MetricThreshold', 200);

% Extract the features.
[f1,vpts1] = extractFeatures(I1, points1);
[f2,vpts2] = extractFeatures(I2, points2);

% Match points and retrieve the locations of matched points.
indexPairs = matchFeatures(f1,f2);
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

% Display the matching points. The data still includes several outliers, 
% but you can see the effects of rotation and scaling on the display of 
% matched features.
figure(1); showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
legend('matched points 1','matched points 2');

% Build 3D depth matrices
scale_ = 5000; fx = 481.2; fy = 480.0; cx = 319.5; cy = 239.5; % Camera params
D1 = double(imread('ecovi_t5/depth/0.png'));
XYZ1 = reproject(D1, scale_, fx, fy, cx, cy);
D2 = double(imread('ecovi_t5/depth/50.png'));
XYZ2 = reproject(D2, scale_, fx, fy, cx, cy);

% Round values in order to find the xyz reprojected coordinates
indxs1 = round(matchedPoints1.Location);
pts1 = getxyz(XYZ1, indxs1);
indxs2 = round(matchedPoints2.Location);
pts2 = getxyz(XYZ2, indxs2);

figure(2)
ptCloud1 = pointCloud(XYZ1);
ptCloud2 = pointCloud(XYZ2);
try
    pcshowMatchedFeatures(ptCloud1,ptCloud2,pointCloud(pts1),pointCloud(pts2))
catch
    pcshowpair(ptCloud1,ptCloud2)
    hold on
    scatter3(pts1(:,1), pts1(:,2), pts1(:,3),50,'m','filled');
    scatter3(pts2(:,1), pts2(:,2), pts2(:,3),50,'g','filled');
    hold off
end
zlim([-1.3 0.5])

% Estimate Transform with the matched points
iter = 10000; ratio = 0.75; thr = 0.05;
[R, t] = ransacTransform(pts1, pts2, iter, ratio, thr);
pts3 = pts1*R+t;

figure(3)
X = XYZ1(:,:,1); Y = XYZ1(:,:,2); Z = XYZ1(:,:,3);
ptCloud3 = pointCloud([X(:), Y(:), Z(:)]*R+t);
pcshowpair(ptCloud3,ptCloud2)
zlim([-1.3 0.5])
hold on
scatter3(pts3(:,1), pts3(:,2), pts3(:,3),50,'m','filled');
scatter3(pts2(:,1), pts2(:,2), pts2(:,3),50,'g','filled');
hold off