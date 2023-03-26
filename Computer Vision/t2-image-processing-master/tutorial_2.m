function tutorial_2(debug, image_folders)
% Default values for the image_folders are the ones provided in the task
if ~exist('image_folders', 'var')
    image_folders = {'./1', './2'};
end
% Debug mode is activated by default in order to easily see how the images
% are processed as they are loaded
if ~exist('debug', 'var')
    debug = true;
end
persistent cameraParams
if isempty(cameraParams)
    [cameraParams, ~] = calibrate_camera();
end
for folderNum = 1:length(image_folders)
    ballOverlay = initializePlot(folderNum);
    folder = image_folders{folderNum};
    imageFiles = dir(fullfile(folder,'*.png'));
    N = length(imageFiles);
    ball = zeros(N,4); % Here I'm assuming that allocating new memory every 
                       % loop is slower than slicing a matrix every loop.
                       % I'm not sure, should investigate
    ballNum = 1;
    for imNum = 1:N
        filename = imageFiles(imNum).name;
        im_time = datetime( ....
            filename(1:end-6), ...
            'InputFormat','yyyy-MM-dd_HH-mm-ss.SSS' ...
            );
        if imNum == 1
            t_ini = im_time;
            im_time = 0;
        else
            im_time = seconds(im_time - t_ini); % seconds
        end
        im = imread(fullfile(folder, filename));
        im_props = findBallWorld(im, cameraParams);
        if ~isempty(im_props.ball)
            % Save the ball coordinates
            ball(ballNum, :) = [im_props.ball.WorldCentroid im_time];
            % Show the ball in the 3D space
            plotBall(ball(1:ballNum,:), im_props.ball.WorldRadius);
            % With three ball points we start to estimate trajectories
            if ballNum > 3
                trajectory = estimateTrajectory(ball(1:ballNum,:));
                % Print the trajectory in the 3D space
                t = linspace(ball(1,4), ball(ballNum,4)+0.2);
                ballFit = [ ...
                    polyval(trajectory(1, :), t); ... % X
                    polyval(trajectory(2, :), t); ... % Y
                    polyval(trajectory(3, :), t); ... % Z
                    ]';
                plotTrajectory(ballFit)
                ballOverlay = plotImage( ... 
                    ballOverlay, im, im_props, ball(ballNum, :), ... 
                    cameraParams, ballFit ... 
                    );
            else
                ballOverlay = plotImage( ... 
                    ballOverlay, im, im_props, ball(ballNum, :), ... 
                    cameraParams ... 
                    );
            end
            ballNum = ballNum + 1;
        else
            % If the ball was not found, we discard the image as a valid point
            ball = ball(1:end-1,:);
            ballOverlay = plotImage(ballOverlay, im, im_props);
        end
        if debug
            keyboard;
        end
    end
end
end

% -----------------------------------------------------------------------------

function plotBall(ball, pointSize)
    subplot(1,2,2)
    hold on
    cla
    scatter3( ... 
        ball(:,1), ... 
        ball(:,3), ... 
        ball(:,2), ... 
        pointSize)
end

function plotTrajectory(ballFit)
    subplot(1,2,2)
    plot3(ballFit(:,1), ballFit(:,3), ballFit(:,2));
end

function ballOverlay = plotImage(ballOverlay, im, im_props, ball, cameraParams, ballFit)
    if isempty(ballOverlay)
        [M, N] = size(im);
        ballOverlay = repmat([0 0 0], M, N);
    end
    if exist('ball', 'var')
        ballOverlay = insertShape(ballOverlay, 'FilledCircle', ... 
            [world2image(ball,cameraParams) im_props.ball.Radius] ...
            );
    end
    subplot(1,2,1)
    imshow(im)
    hold on
    h = imshow(ballOverlay);
    alpha_ = (im2gray(ballOverlay) > 0)*0.25;
    set(h, 'AlphaData', alpha_);
    if exist('ballFit', 'var')
        trajectory = world2image(ballFit, cameraParams);
        plot(trajectory(:,1), trajectory(:,2))
    end
    hold off
end

function ballOverlay = initializePlot(folderNum)
    figure(folderNum)
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.2, 0.3, 0.7, 0.5]);
    subplot(1,2,2)
    ax = newplot();
    ax.XAxisLocation = 'top';
    ax.YAxisLocation = 'left';
    ax.ZDir = 'reverse';
    ax.View = [15,30];
    grid on
    xlabel('X (mm)')
    xlim([-2000 2000])
    ylabel('Z (mm)')
    ylim([0 10000])
    zlabel('Y (mm)')
    zlim([-1500 1500])
    ballOverlay = null(1);
end
