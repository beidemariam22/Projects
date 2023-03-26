% System parameters
N = 3;           % Number of signals
Fs = 1000;       % Sampling frequency [Hz]
s = 2;           % Signal length [s]
T = 1/Fs;        % Sampling time step [s]
L = s*Fs;        % Signal length (number of samples)
t = (0:L-1)*T;   % Time base
f = 0:1/s:Fs/2;  % Frequency base

% Signal creation
A = rand([1 N]);                    % Amplitude
A = A./max(A);
[A, ordering] = sort(A, 'descend');
F = round(rand([1 N])*Fs/20);       % Frequency [Hz]
F = F(ordering);
P = rand([1 N])*2*pi;               % Phase shift
P = P(ordering);

varNames = {'A', 'F', 'P'};
result = table(A, F, P, 'VariableNames', varNames, 'RowNames', {'Original'});

% Generate the signal
x = combine_sinusoids(A,F,P,t);
[~, A_original, P_original] = DFT(x,L);
int_x = cumtrapz(abs(x));
int_x = int_x(L);

noise_strengths = 0:1:4; % Test with several noise strengths
% noise_strengths = ones(1)*0.5; % Test with several noise strengths
len_noise_strengths = length(noise_strengths);
figure(4);
layout = tiledlayout(len_noise_strengths,3,'TileSpacing','compact','Padding','compact');
for k = 1:1:len_noise_strengths
    % Add noise to the original signal
    x_noisy = x + randn([1 L])*noise_strengths(k);
    % Discrete Fourier Transform
    [~, A, P] = DFT(x_noisy,L);
    % Restore the signal
    [ x_restored, A_restored, F_restored, P_restored ] = restore_signal(A, P, N, f, t);
    result = [result; table(A_restored, F_restored, P_restored, ... 
        'RowNames', {sprintf('Noise strength %d%%', noise_strengths(k)*100)}, ... 
        'VariableNames', varNames)];
    [~, A_restored, P_restored] = DFT(x_restored,L);
    % Check the error
    E = abs(x-x_restored);
    % cumtrapz(t, E)
    int_E = cumtrapz(E);
    int_E = int_E(L);
    E_rel = int_E/int_x;

    % Plot everything
    nexttile
    plot(x_noisy, 'DisplayName', 'Noisy')
    hold on;
    plot(x, 'DisplayName', 'Original')
    plot(x_restored, 'DisplayName', 'Reconstructed', 'LineWidth', 2)
    plot(E, '--', 'DisplayName', 'Error')
    xlabel("Sample Number");
    ylabel("Amplitude");
    ylim([-5 5])
    if k==len_noise_strengths
        lgd = legend;
    end
    hold off;
    nexttile
    plot(f, A, 'DisplayName', 'Noisy')
    hold on;
    plot(f, A_original, 'DisplayName', 'Original')
    plot(f, A_restored, 'DisplayName', 'Reconstructed')
    xlabel("Frequency [Hz]");
    xlim([0 Fs/20])
    ylabel("Amplitude");
    ylim([0 1.5])
    title(sprintf('Noise strength %d%% Error %d%%', noise_strengths(k)*100, round(E_rel*100)))
    hold off;
    nexttile
    plot(f, P, 'DisplayName', 'Noisy')
    hold on;
    plot(f, P_original, 'DisplayName', 'Original')
    plot(f, P_restored, 'DisplayName', 'Reconstructed')
    xlabel("Frequency [Hz]");
    xlim([0 Fs/20])
    ylabel("Phase");
    ylim([-5 5])
    hold off;
end
lgd.Layout.Tile = 'North';
result

function x = combine_sinusoids(A,F,P,t)
    x = sum(A' .* cos(2 * pi * F' * t + P'));
end

function [Y, A, P] = DFT(x,L)
    % Calculate fourier transform
    Y = fft(x);     % Fast Fourier Transform
    A = abs(Y);     % Amplitude
    A = A/L;        % Amplitude normalization
    A = A(1:L/2+1); % Cut important part 
    A(2:end-1) = 2*A(2:end-1);
    P = angle(Y);   % Phase
    P = P(1:L/2+1); % Cut important part
end

function [x, A, F, P] = restore_signal(A, P, N, f, t)
    % Restore signal
    [ A_, I_ ] = findpeaks(A);
    [ A, I ] = maxk(A_,N);
    I = I_(I);
    F = f(I);
    P = P(I);
    x = combine_sinusoids(A,F,P,t);
end
