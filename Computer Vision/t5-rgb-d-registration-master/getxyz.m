function xyz = getxyz(XYZ, indxs)
    if ~isequal(size(indxs,2), 2)
        error('indxs should be an Mx2 matrix')
    end
    len = size(indxs,1);
    xyz = zeros(len,3);
    for k = 1:len
        xyz(k,:) = XYZ(indxs(k,2), indxs(k,1), :);
    end