function y = generate(mult, n)
% GENERATE Generate a random signal with controlable distribution.
%   GENERATE(mult) 
%
%   GENERATE(mult, N) 
if nargin == 1
    n = 128;
else
    n = floor(double(n));
end
x = random('Uniform',0,1,mult*n,1);
y = zeros(n,1);
for k = 1:1:n
    y(k) = sum(x(k:1:k+(mult-1)));
end
end