function [pts_curr, pts_next, matchedPts_curr, matchedPts_next] = matchPoints(I_curr, I_next)
    I_curr = rgb2gray(I_curr);
    I_next = rgb2gray(I_next);

    % Find the SURF features. MetricThreshold controls the number of detected
    % points. To get more points make the threshold lower.
    points_curr = detectSURFFeatures(I_curr, 'MetricThreshold', 200);
    points_next = detectSURFFeatures(I_next, 'MetricThreshold', 200);

    % Extract the features.
    [f_curr,vpts_curr] = extractFeatures(I_curr, points_curr);
    [f_next,vpts_next] = extractFeatures(I_next, points_next);

    % Match points and retrieve the locations of matched points.
    indexPairs = matchFeatures(f_curr,f_next);
    matchedPts_curr = vpts_curr(indexPairs(:,1));
    matchedPts_next = vpts_next(indexPairs(:,2));

    pts_curr = round(matchedPts_curr.Location);
    pts_next = round(matchedPts_next.Location);