close all
addpath('lib')
initModelData; trajectoryData;

% Tasks 1-2
simout = sim('accurateManipulatorModel');
posAccurate = get(simout.yout, 'posAccurate');
V = get(simout.yout, 'V');
simout = sim('simplifiedManipulatorModel');
posSimplified = get(simout.yout, 'posSimplified');
[posAccurate, posSimplified] = synchronize( ... 
    posAccurate.Values, posSimplified.Values, 'union');

f = figure('Name', 'Manipulator Model', 'NumberTitle', 'off');
yyaxis left
plot(V.Values, 'DisplayName', 'V', 'LineWidth', 2);
yyaxis right
ylabel('Rotor Position')
hold on;
plot(posAccurate, 'DisplayName', 'posAccurate');
plot(posSimplified, 'DisplayName', 'posSimplified', 'LineWidth', 2);
plot(posSimplified-posAccurate, 'DisplayName', 'difference');
title('Accurate vs Simplified model')
legend('Location', 'east');
hold off;
saveas(f, [pwd '/report/modelAccurateVsSimplified.png'])

% Task 3-4
controlPD;
fprintf('w = %f, Kp = %f, Kd = %f\n', w, Kp, Kd);
titles = { ... 
    'PD control; Cubic polynomial reference trajectory', ...
    'PD control; LSPB reference trajectory', ...
    'PD control; Step reference trajectory' ...
};
fignames = { ...
    'PD_cubic', ...
    'PD_LSPB', ...
    'PD_step' ...
}; 
disturbance = 0;
trajectories = [CUBIC_, LSPB_, STEP_];
for k = 1:length(trajectories)
    trajectory = trajectories(k);
    [q, qd, v, vd, eq] = runPD;
    fprintf('%s max pos error: %f\n', ... 
        fignames{k}, max(abs([max(eq.Values) min(eq.Values)])));
    f = figure('Name', fignames{k}, 'NumberTitle', 'off');
    plotPD(titles{k}, q, qd, v, vd, eq);
    saveas(f, [pwd '/report/' fignames{k} '.png'])
end

% Task 5
titles = { ... 
    'PD control; Cubic polynomial reference trajectory; Disturbed', ...
    'PD control; LSPB reference trajectory; Disturbed', ...
};
fignames = { ...
    'PD_cubic_disturbed', ...
    'PD_LSPB_disturbed', ...
}; 
disturbance = 2;
trajectories = [CUBIC_, LSPB_];
for k = 1:length(trajectories)
    trajectory = trajectories(k);
    [q, qd, v, vd, eq] = runPD;
    fprintf('%s ss pos error: %f\n', fignames{k}, -R/(Km*Kp)*disturbance/r);
    f = figure('Name', fignames{k}, 'NumberTitle', 'off');
    plotPD(titles{k}, q, qd, v, vd, eq);
    saveas(f, [pwd '/report/' fignames{k} '.png'])
end

% Task 6
controlPID;
fprintf('w = %f, Kp = %f, Kd = %f, Ki = %f\n', w, Kp, Kd, Ki);
titles = { ... 
    'PID control; Cubic polynomial reference trajectory', ...
    'PID control; LSPB reference trajectory', ...
    'PID control; Step reference trajectory' ...
    'PID control; Cubic polynomial reference trajectory; Disturbed', ...
    'PID control; LSPB reference trajectory; Disturbed', ...
};
fignames = { ...
    'PID_cubic', ...
    'PID_LSPB', ...
    'PID_step', ...
    'PID_cubic_disturbed', ...
    'PID_LSPB_disturbed' ...
}; 
disturbances = [0 0 0 2 2];
trajectories = [CUBIC_, LSPB_, STEP_, CUBIC_, LSPB_];
for k = 1:length(trajectories)
    trajectory = trajectories(k);
    disturbance = disturbances(k);
    [q, qd, v, vd, eq] = runPID;
    fprintf('%s max pos error: %f\n', ... 
        fignames{k}, max(abs([max(eq.Values) min(eq.Values)])));
    f = figure('Name', fignames{k}, 'NumberTitle', 'off');
    plotPID(titles{k}, q, qd, v, vd, eq);
    saveas(f, [pwd '/report/' fignames{k} '.png'])
end

% Task 7
figname = 'PIDfeedforward_sinusoidal';
f = figure('Name', figname, 'NumberTitle', 'off');
trajectory = SINUSOIDAL_;
disturbance = 0;
l = tiledlayout(2, 1);
title(l, 'PID with and without feedforward; Sinusoidal reference trajectory')
[q, qd, v, vd, eq] = runPID;
[qff, ~, vff, ~, effq] = runPIDfeedforward;
nexttile;
plot(qd.Values, 'DisplayName', 'Position Reference');
hold on;
plot(q.Values, 'DisplayName', 'Position without feedforward');
plot(qff.Values, 'DisplayName', 'Position with feedforward');
title('Position')
legend('Location', 'southoutside', 'Orientation', 'horizontal');
ylabel('Position (radians)')
hold off;
nexttile;
plot(eq.Values, 'DisplayName', 'Error position without feedforward');
hold on;
plot(effq.Values, 'DisplayName', 'Error position with feedforward');
title('Error Position')
legend('Location', 'southoutside', 'Orientation', 'horizontal');
ylabel('Error Position (rad)')
hold off;
saveas(f, [pwd '/report/' figname '.png'])