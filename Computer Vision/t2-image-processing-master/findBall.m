function results = findBall(im)
%Image Processing Function
%
% IM      - Input image.
% RESULTS - A scalar structure with the processing results.

% Color Tresholder
BW = createMask(im);

% Open mask with disk
radius = 1;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imopen(BW, se);

% Close mask with disk
radius = 10;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imclose(BW, se);

% Analyze region
props = regionprops(...
    BW, ...
    {'MajorAxisLength', 'Centroid', 'Eccentricity', 'Circularity'}...
    );
props = struct2table(props);
props = props(...
    props.Circularity<Inf ...
    & props.Eccentricity>0 ...
    & props.MajorAxisLength>50 ...
    & (props.Eccentricity < 0.6 | props.Circularity > 0.7) ...
    ,:);
% props = sortrows(props,['Eccentricity','Circularity']);
props = sortrows(props,'Eccentricity');
if height(props) > 0
    ball = table2struct(props(1,:));
    ball.Radius = ball.MajorAxisLength/2;

    % Create marked image
    im = insertMarker(im, ball.Centroid, 'o', ...
        'Size', round(ball.Radius) ...
        );
else
    ball = null(1);
end

% Create masked image
maskedImage = im;
maskedImage(repmat(~BW,[1 1 3])) = 0;

results.bw = BW;
results.image = im;
results.maskedImage = maskedImage;
results.regions = props;
results.ball = ball;
