function [B, C1, C10] = task_4_and_5(task, N, plot_result)
    if ~exist("N", "var")
        N = 1000;
    end
    if task == 4
        B = randn(1,N);
    elseif task == 5
        B = ones(1,N);
    else
        error('Invalid task input. One can select between task 4 or 5.')
    end
    if ~exist("plot_result", "var")
        plot_result = false;
    end
    B = B/sum(B);
    C1 = conv(B, B);
    C1 = C1/sum(C1);
    C10 = C1;
    for k = 1:10
        C10 = conv(C10,B);
        C10 = C10/sum(C10);
    end
    if plot_result
        figure(task)
        clf
        nexttile()
        plot(C10, "DisplayName", "C10")
        title("C10")
        nexttile()
        plot(C1, "DisplayName", "C1")
        title("C1")
        nexttile()
        plot(B, "DisplayName", "B")
        title("B")
        nexttile()
        plot(C10, "DisplayName", "C10")
        hold on
        plot(C1, "DisplayName", "C1")
        plot(B, "DisplayName", "B")
        hold off
        title("All")
        legend
    end