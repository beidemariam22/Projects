function plotPID(title_, q, qd, v, vd, eq)
    l = tiledlayout(3, 1);
    title(l, title_)
    nexttile;
    plot(qd.Values, 'DisplayName', 'Position Reference');
    hold on;
    plot(q.Values, 'DisplayName', 'Position');
    title('Position')
    legend('Location', 'east');
    ylabel('Position (radians)')
    hold off;
    nexttile;
    plot(vd.Values, 'DisplayName', 'Velocity Reference');
    hold on;
    plot(v.Values, 'DisplayName', 'Velocity');
    title('Velocity')
    legend('Location', 'east');
    ylabel('Velocity (rad/s)')
    hold off;
    nexttile;
    plot(eq.Values, 'DisplayName', 'Error Position');
    title('Error Position')
    legend('Location', 'northeast');
    ylabel('Error Position (rad)')