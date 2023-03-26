D1 = imread('ecovi_t5/depth/0.png');
I1 = imread('ecovi_t5/rgb/0.png');
scale_ = 5000; fx = 481.2; fy = 480.0; cx = 319.5; cy = 239.5;
XYZ = reproject(D1, scale_, fx, fy, cx, cy);
figure()
pcshow(XYZ,I1);