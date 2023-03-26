function y = myconv(x, h, shape)
%CONV Convolution and polynomial multiplication.
%   C = CONV(A, B) convolves vectors A and B.  The resulting vector is
%   length MAX([LENGTH(A)+LENGTH(B)-1,LENGTH(A),LENGTH(B)]). If A and B are
%   vectors of polynomial coefficients, convolving them is equivalent to
%   multiplying the two polynomials.
%
%   C = CONV(A, B, SHAPE) returns a subsection of the convolution with size
%   specified by SHAPE:
%     'full'  - (default) returns the full convolution,
%     'same'  - returns the central part of the convolution
%               that is the same size as A.
%     'valid' - returns only those parts of the convolution 
%               that are computed without the zero-padded edges. 
%               LENGTH(C)is MAX(LENGTH(A)-MAX(0,LENGTH(B)-1),0).
%
%   Class support for inputs A,B: 
%      float: double, single

if ~isvector(x) || ~isvector(h)
    error(message('MATLAB:conv:AorBNotVector'));
end
if nargin < 3
    shape = 'full';
end

if ~ischar(shape) && ~(isstring(shape) && isscalar(shape))
error(message('MATLAB:conv:unknownShapeParameter'));
end
if isstring(shape)
    shape = char(shape);
end
N = length(x);
M = length(h);
y = zeros(1,N+M-1);
% Flip and transpose h
h = flip(h)';
% Extend x with periodic assumption
x = [x(end-M+2:end) x x(1:M-1)];
% Convolution machine
for i=1:(N+M-1)
    y(i) = x(1, i:i+M-1)*h;
end
if shape(1) == 'S' || shape(1) == 's' % same
    y = y(1, 1:N);
elseif shape(1) == 'V' || shape(1) == 'v' % valid
    y = y(M:end-M);
end