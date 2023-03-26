function tutorial_5_door(debug)
    if ~exist('debug', 'var')
        debug = false;
    end
    % load sample image
    I=imread('door.jpg');

    figure(5)
    layout = tiledlayout(1, 3);
    nexttile;
    imshow(I);

    % prepare reference points
    if ~debug
        title(layout, 'Select 4 points corresponding to the 4 door edges')
        points_in = get_trapezium();
    else
        points_in = [108.6037   69.8679; ...
                     488.5065   90.6135; ...
                     128.0527  745.3947; ...
                     424.9733  746.6912];
    end
    points_out = [0 0; 90 0; 0 200; 90 200]*3;

    % calculate the homography - this function should be implemented by you
    H = calculate_homography(points_in, points_out);

    % prepare image reference information
    Rin=imref2d(size(I));

    % convert homography matrix to the Matlab projective transformation
    t = projective2d(H');

    % warp the image and get the output reference information
    [I2, Rout]=imwarp(I, Rin, t);
    nexttile;
    imshow(I2);
    title(layout, 'Homography based on 4 pairs of points')

    % crop the output based on the reference information
    I3 = crop_image(I2, Rout, points_out);
    nexttile;
    imshow(I3);