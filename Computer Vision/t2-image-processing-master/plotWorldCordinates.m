plotWorldCoordinatesFromFolderImages('./1')
hold on
plotWorldCoordinatesFromFolderImages('./2')
plotWorldCoordinatesFromFolderImages('./train')
hold off

% -------------------------------------------------------------------------

function plotWorldCoordinatesFromFolderImages(folder)
    imageFiles = dir(fullfile(folder,'*.png'));
    N = length(imageFiles);
    ball = zeros(N,3);
    for imNum =1:N
        filename = imageFiles(imNum).name;
        im = imread(fullfile(folder, filename));
        result = findBallWorld(im);
        if ~isempty(result.ball)
            ball(imNum,:) = result.ball.WorldCentroid;
        end
    end
    % Remove the points where the ball is not found
    ball = ball(ball(:,3)>0,:);
    % Plot the  ball points
    scatter3(ball(:,1), ball(:,3), ball(:,2), 200)
    ax = gca;
    ax.XAxisLocation = 'top';
    ax.YAxisLocation = 'left';
    ax.ZDir = 'reverse';
    ax.View = [15,30];
    xlabel('X')
    ylabel('Z')
    zlabel('Y')
end
