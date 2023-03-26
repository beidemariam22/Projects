% Task 1
% Generate a rectangular signal A with 1000 samples and a period of 200
% samples, with an amplitude of {-1, +1}. Add Gaussian noise with 0 mean and 
% 0.1 sigma.
A = task_1(true);
% Task 2
% Create three simple filters with a size of [1x3]:
%     F1 - averaging filter [1/3 1/3 1/3]
%     F2 - Gaussian filter [1/4 1/2 1/4]
%     F3 - edge-detecting filter [-1 0 1]
% Convolve input signal A with each of the filters. 
% Expand filters to a bigger size (e.g. 5x1) and apply to signal A. Remember to
% normalize the filter (when applicable).
task_2(A, true);
% * What are the results? 
% The results are three signals with the same length as the original one. In 
% the case of the Averaging and Gaussian filters, the output signal has less 
% noice than the original one. The EdgeDetecting filter outputs a signal which
% only shows the changes of values of the original signal. Leading to peaks 
% every half period.
% * What is the goal of each type of filter? 
% The Averaging and Gaussian filters indend to reduce the noise of a singal, 
% while the EdgeDetecting highlights the big changes in value of the signal.
% * What happens, if filters are not normalized? 
% The output signal gets multiplied by the sum of the components of the 
% convolution kernel. Therefore a non normalized filter increases or reduces
% the original signal amplitude. It applies an scaling factor.
% * What is the difference in result between 3 and 5 element filters?
% The Averaging and Gaussian filters noise reduction is proportional to the
% number of elements of the kernel. In the case of the Averaging filter, the 
% side effect is that edges or sudden changes of the original signal become 
% less sudden as they are averaged over a higher number of samples. In the case
% of the Gaussian filter, the output signal will experience a higher phase 
% shift in cmparisson to the original signal. Lastly, the EdgeDetecting filter
% detects less noise as edges but the phase shift and the edge thickness 
% increases too. Please refer to the images stored in this same repository.

% Task 3
% Implement your own convolution function using the equation from the lecture.
% Compare your results with those obtained in task 2.
task_3(A, true);
% We obtain the same results with the exception of the beggining and the end
% of the convolved signal. Matlab's built-in function extends the original
% signals with zeros in order to perform the convolution. Instead, our custom
% function assumes that the original signal is periodic and extends it 
% accordingly to perform the convolution.

% Task 4
% Use the random number generator to generate 1000 samples of random signal B
% (any kind of random signal). Normalize it to have a sum of all elements equal
% to one (i.e. sum(B) = 1). Convolve signal B with itself once: C = conv(B, B)
% and normalize result to have a sum of 1 (i.e. sum(C) = 1). Compare signal B
% with C. Convolve signal C with B ten more times (C = conv(C, B) and normalize
% it every time to 1) and watch the result.
task_4_and_5(4, 1000, true);
% The signal starts to get a Gaussian shape

% Task 5
% Repeat task 4, but this time use the constant function as input signal B 
% (B = [1 1 1 ...] / 1000).
task_4_and_5(5, 1000, true);
% * What is the final result this time?
% The final result is an approximation to a Gaussian distribution. In reality 
% it is the Irwin-Hall distribution as I already pointed out in the tutorial 2.