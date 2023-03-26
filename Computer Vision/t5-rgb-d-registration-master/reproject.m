function XYZ = reproject(depth, scale, fx, fy, cx, cy, swapZY)
% calculate XYZ matrix based on a given depth matrix
% XYZ should have the same width and height as depth with three planes (x, y and z)
% scale: number of units in depth corresponding to one meter
% fx, fy: focal length
% cx, cy: principal point
if ~exist('swapZY', 'var')
    swapZY=true;
end
z = double(depth)/scale;
s = size(z);
[x, y] = meshgrid(1:s(2), 1:s(1));
X = z.*(x-cx)./fx;
Y = z.*(y-cy)./fy;
if swapZY
    XYZ = cat(3, X, z, -Y);
else
    XYZ = cat(3, X, Y, z);
end