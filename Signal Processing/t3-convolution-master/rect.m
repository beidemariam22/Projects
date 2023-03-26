function A = rect(period, N, bound)
    period_2 = period/2;
    if ~exist("bound", "var")
        bound = 1;
    end
    if length(bound) == 1
        A_min = -bound;
        A_max = bound;
    elseif length(bound) == 2
        A_min = bound(1);
        A_max = bound(2);
    else
        error("Invalid input")
    end
    % Generate the rectangular signal
    A = ones(1,N)*A_max;
    for k=2:2:ceil(N/period_2)
        start_ = ((k-1)*period_2+1);
        end_ = min(k*period_2,N);
        A(1, start_:end_) = A_min;
    end