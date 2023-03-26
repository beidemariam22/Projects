clc; clear;
%% Task 1
% Generate a random noise digital signal having normal distribution with
% different parameter sets (use random function):
% 
%     N1 - mean = 0 and standard deviation = 1.0.
%     N2 - mean = 2 and standard deviation = 2.
% 
% Use 512 samples.
% 
%     U - Generate 512 samples of a signal uniformly distributed in the 
%         interval.
% 
% Compute the real mean and standard deviation of every generated signal. 
% What are the differences between observed statistics and underlying 
% processes? Plot the generated signals with equal scale of amplitude.
N = 512;
[N1, N2, U] = generate_signals(N);
figure(1)
clf
subplot(2,3,[1,2,3]);
pN1 = plot(N1, "color", "b", "DisplayName", "N1 (Normal) m=0, s=1");
hold on; 
pN2 = plot(N2, "color", "g", "DisplayName", "N2 (Normal) m=2, s=2");
pU = plot(U, "color", "r", "DisplayName", "U (Uniform) [1,3]");
xlim([0,N])
ylim( [ -6,8 ] )
title("Generated Signals")
legend
hold off;
next_subplot = 4;
for plt = [pN1, pN2, pU]
    copyobj(plt,subplot(2,3,next_subplot));
    title(plt.DisplayName);
    xlim([0,N])
    ylim( [ -6,8 ] )
    next_subplot = next_subplot + 1;
end

%% Task 2
% For the signals N1, N2 and U generated in previous exercise compute 
% their running statistics (mean and standard deviation) and plot the 
% results.
% 
% Example: for sample data given below:
% 
% [1,2,3,2,3,4]
% 
% Expected vector of moving average would be:
% 
% [1,1.5,2,2,2.2,2.5]
% 
% Notice: solutions, in which whole vector of incoming numbers is stored 
% will be scored lower.
signals = { 
    { "N1", "b", N1, [-1,1], [0.5, 1.5] }, ...
    { "N2", "g", N2, [1,3], [1,3] }, ...
    { "U", "r", U, [1.5,2.5], [0,1] }, ...
    };
len_signals = length(signals);
figure(2);
next_subplot = 1;
for bucket = signals 
    signal = bucket{1}{3};
    color_ = bucket{1}{2};
    name = bucket{1}{1};
    [RM, RS] = running_statistics(signal);
    subplot(2,len_signals,next_subplot)
    plot(RM, "color", color_)
    xlim([0,N])
    ylim(bucket{1}{4});
    title(sprintf("Running Mean of %s",name))
    subplot(2,len_signals,next_subplot+len_signals)
    plot(RS, "color", color_)
    xlim([0,N])
    ylim(bucket{1}{5});
    title(sprintf("Running Standard Deviation of %s",name))
    next_subplot = next_subplot + 1;
end

%% Task 3
% For the signal amplitudes N1, N2 and U generated in previous exercise 
% compute their histograms with 90 bins and 10 bins.
figure(3)
next_subplot = 1;
for nbins = [10, 90]
    for bucket = signals 
        signal = bucket{1}{3};
        color_ = bucket{1}{2};
        name = bucket{1}{1};
        subplot(2,len_signals,next_subplot)
        histogram(signal, nbins, "FaceColor", color_, "EdgeColor", "none");
        title(sprintf("Histogram of %s. %i bins", name, nbins))
        next_subplot = next_subplot + 1;
    end
end
% One can observe that when the number of bins for the histogram is too large
% only a few samples fall into each bin, making high statistical noise and
% making it difficult to estimate the amplitude of the underlying Probability
% Mass Function.

%% Task 4
% Use the random number generator to generate 128 numbers between zero and 
% one with an equal probability (uniform distribution). Create and plot 
% the histogram of this sample vector. Repeat the process for 256 samples 
% and add every two consecutive values obtained from the random number 
% generator to create a sample of a new signal. Plot again its histogram.
% 
% Repeat this procedure for 4x128, 6x128 and 8x128 random numbers, while 
% adding four, six nad eight consecutive values, appropriately, to 
% generate a sample. Observe the results and comment the different 
% histograms.
mults = [1,2,4,6,8,10];
subplot_rows = ceil(length(mults)/3);
figure(4)
next_subplot = 1;
for mult = mults
    y = generate(mult, 128);
    subplot(subplot_rows, 3, next_subplot)
    histogram(y, 15)
    title(sprintf("Adding %i", mult))
    next_subplot = next_subplot + 1;
end
%% Why does the addition histogram seem a gaussian probability distribution?
% The Central Limit Theorem teaches us that the sum of random numbers becomes
% normally distributed as more and more of the random numbers are added 
% together. Particularyly, the sum of n random variables with (continuous) 
% uniform distribution on [0,1] has distribution called the Irwin-Hall 
% distribution.
% From Wikipedia: https://en.wikipedia.org/wiki/Irwin%E2%80%93Hall_distribution
% The generation of pseudo-random numbers having an approximately normal 
% distribution is sometimes accomplished by computing the sum of a number of 
% pseudo-random numbers having a uniform distribution; usually for the sake of 
% simplicity of programming. Rescaling the Irwin–Hall distribution provides the
% exact distribution of the random variates being generated.