function p_img = world2image(p_world, cameraParams)
    f = cameraParams.Intrinsics.FocalLength;
    c = cameraParams.Intrinsics.PrincipalPoint;
    p_img = p_world(:,1:2).*(f./p_world(:,3)) + c;
end