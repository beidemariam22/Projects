function tutorial_3(debug)
    % Debug mode is activated by default in order to easily see how the images
    % are processed as they are loaded
    if ~exist('debug', 'var')
        debug = true;
    end
    persistent stereoParams
    persistent imageFileNames1
    persistent imageFileNames2
    if isempty(stereoParams) || isempty(imageFileNames1) || isempty(imageFileNames2)
        [ stereoParams, imageFileNames1, imageFileNames2 ] = calibrateCameras;
    end
    [player3D, h1, h2] = initializePlot();
    for k=1:1:length(imageFileNames1)
        %% Rectify images using the stereo calibration
        I1 = imread(imageFileNames1{k});
        I2 = imread(imageFileNames2{k});
        [J1, J2] = rectifyStereoImages(I1, I2, stereoParams);
        imshow(cat(3, J1, J2, J2), 'Parent', h1);
        
        %% Disparity Map
        dispRange = [16, 464];
        disparityMap = disparity(J1, J2, ...
            'DisparityRange', dispRange, ...
            'BlockSize', 15, ...
            'ContrastThreshold', 0.3, ...
            'UniquenessThreshold', 50 );
        imshow(disparityMap, dispRange, 'Parent', h2);
        colormap(h2,jet) 
        colorbar

        %% Reconstruct 3D scene from disparity map
        points3D = reconstructScene(disparityMap, stereoParams);
        % expand gray image to three channels (simulate RGB)
        J1_col = cat(3, J1, J1, J1);
        % Convert to meters and create a pointCloud object
        points3D = points3D ./ 1000;
        ptCloud = pointCloud(points3D, 'Color', J1_col);
        % Visualize the point cloud
        view(player3D, ptCloud);
        if debug || k==1
            fprintf('Press "continue" to continue\n')
            keyboard;
        else 
            pause(1);
        end
    end

function [player3D, h1, h2] = initializePlot()
    figure(1)
    subplot(2,1,1)
    h1 = newplot();
    subplot(2,1,2)
    h2 = newplot();
    player3D = pcplayer([-1, 1], [-1, 1], [0, 4], ... 
        'VerticalAxis', 'y', 'VerticalAxisDir', 'down');