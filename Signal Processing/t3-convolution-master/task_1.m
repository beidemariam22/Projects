% Generate a rectangular signal A with 1000 samples and a period of 200 
% samples, with an amplitude of {-1, +1}. Adds Gaussian noise with 0 mean and 
% 0.1 sigma.
% plot_result (bool): Choose whether to plot the resulting signal or not.
%                     Defaults to false.
function A = task_1(plot_result)
    N = 1200;
    period = 200;
    A_max = 1;
    A_min = -1;
    noise_sigma = 0.1;
    if ~exist("plot_result", "var")
        plot_result = false;
    end
    % Generate the rectangular signal
    A = rect(period, N, [A_min, A_max]);
    % Add random noise
    A = A+noise_sigma*randn(size(A));
    % Plot signal if needed
    if plot_result
        figure(1)
        plot(A)
        title('Task 1. Signal A')
        ylim([-1.5,1.5])
        xlim([0, N])
    end