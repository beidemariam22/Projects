% RM is the vector of running mean
% RS is the vector of running standard deviation
function [RM, RS] = running_statistics(x)
  % prepare output vectors
  RM = zeros(size(x));
  RS = zeros(size(x));

  % calculate running statistics
  sum_ = 0;
  sum_of_squares = 0;
  for n = 1:length(x)
    sum_ = sum_ + x(n);
    sum_of_squares = sum_of_squares + x(n)^2;
    RM(n) = sum_/n;
    RS(n) = sqrt((sum_of_squares-sum_^2/n)/n);
  end
end