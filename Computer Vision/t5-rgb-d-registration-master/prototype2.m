% Fixed parameters
scale_ = 5000; fx = 481.2; fy = 480.0; cx = 319.5; cy = 239.5; % Camera params
iter = 1000; ratio = 0.5; thr = 0.06; % RANSAC params
gridStep = 0.01; % Refine params
% Dataset
rgbImagePaths = dir([pwd '/ecovi_t5/rgb/*.png']);
rgbImagePaths = strcat({rgbImagePaths.folder}, {'/'}, {rgbImagePaths.name});
depthImagePaths = dir([pwd '/ecovi_t5/depth/*.png']);
depthImagePaths = strcat({depthImagePaths.folder}, {'/'}, {depthImagePaths.name});
N = length(rgbImagePaths);

% Create the initial Point Cloud
I_curr = imread(rgbImagePaths{1});
D_curr = imread(depthImagePaths{1});
XYZ_curr = reproject(D_curr, scale_, fx, fy, cx, cy, false);
tform = affine3d;
pc_curr = pointCloud(XYZ_curr, 'Color', I_curr);
pc = pc_curr; figure(1); pcshow(pc);

% Iterate over the dataset and expand the Point Cloud
for n=2:N
    fprintf('Image %d\n', n)
    I_next = imread(rgbImagePaths{n});
    D_next = imread(depthImagePaths{n});

    % Calculate the reprojection
    XYZ_next = reproject(D_next, scale_, fx, fy, cx, cy, false);
    pc_next=pointCloud(XYZ_next, 'Color', I_next);

    % Find the matching point pairs between the images
    [pts_curr, pts_next] = matchPoints(I_curr, I_next);

    % Read the 3D coordinates of the matched points
    pairs_cnt = size(pts_curr, 1);
    pts_curr_3d = zeros(pairs_cnt, 3);
    pts_next_3d = zeros(pairs_cnt, 3);

    for i=1:pairs_cnt
        % Points from matching are in u-v order, i.e. col-row
        pts_curr_3d(i,:) = XYZ_curr(pts_curr(i, 2), pts_curr(i, 1), :);
        pts_next_3d(i,:) = XYZ_next(pts_next(i, 2), pts_next(i, 1), :);
    end

    % Estimate transform between point clouds
    [R, T] = ransacTransform(pts_next_3d, pts_curr_3d, iter, ratio, thr);
    [R, T] = refineTransform(pc_next, pc_curr, R, T);
    tform_next = rigid3d(R, T);
    tform = affine3d(tform.T*tform_next.T);

    % Merge the transformed point cloud
    pc_tran = pctransform(pc_next, tform);
    pc = pcmerge(pc, pc_tran, gridStep);
    pcshow(pc);
    drawnow;
    keyboard;

    % Prepare for the next iteration
    I_curr=I_next; D_curr=D_next; XYZ_curr=XYZ_next; pc_curr=pc_next;
end