function tutorial_5_panorama_stitching(debug)
    if ~exist('debug', 'var')
        debug = false;
    end
    % load images
    I = cell(1,2);
    I{1}=imread('974-1.jpg');
    I{2}=imread('975-1.jpg');

    figure(5)
    tiledlayout(1, 1);
    nexttile;
    points_in = cell(1,2);
    for img = 1:1:length(I)

        % prepare reference points
        if ~debug
            imshow(I{img});
            title(sprintf('Select 4 points on the image %d', img))
            points_in{img} = get_trapezium();
            fprintf('Points of image %d\n', img);
            disp(points_in{img});
        elseif img == 1
            points_in{img}=[528.0000  255.0000; ...
                            662.0000  257.0000; ...
                            530.0000  330.0000; ...
                            663.0000  332.0000];
        elseif img == 2
            points_in{img}=[ 20.0000  263.0000; ...
                            158.0000  273.0000; ...
                             20.0000  342.0000; ...
                            158.0000  350.0000];
        end
        if ~exist('points_out', 'var')
            s = points_in{img}(4,:) - points_in{img}(1,:);
            points_out = [0 0; s(1) 0; 0 s(2); s(1) s(2)];
        end
        % calculate the homography - this function should be implemented by you
        H = calculate_homography(points_in{img}, points_out);
        % prepare image reference information
        Rin=imref2d(size(I{img}));
        % convert homography matrix to the Matlab projective transformation
        t = projective2d(H');
        % warp the image and get the output reference information
        [I2_, Rout_]=imwarp(I{img}, Rin, t);
        if ~exist('I2', 'var')
            I2 = I2_;
        else
            I2 = imfuse(I2, Rout, I2_, Rout_, 'blend');
        end
        Rout = Rout_;
    end

    imshow(I2);
    title('Panorama stitching')