function I = crop_image(I, Rout, points_out)
    border = 10;
    rect = [ points_out(1,1) - Rout.XWorldLimits(1) - border ...
             points_out(1,2) - Rout.YWorldLimits(1) - border...
             points_out(4,:) - points_out(1,:) + 2*border];
    I = imcrop(I,rect);