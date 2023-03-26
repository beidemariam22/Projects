function f = filters()
    persistent f_
    if isempty(f_)
        s_3.Averaging = [1 1 1]; 
        s_3.Gaussian = [2 4 2];
        s_3.EdgeDetecting = [-1 0 1];
        f.Size_3 = s_3;
        n_s_3.Averaging = s_3.Averaging/sum(s_3.Averaging);
        n_s_3.Gaussian = s_3.Gaussian/sum(s_3.Gaussian);
        f.Normalized_Size_3 = n_s_3;
        s_5.Averaging = [1 1 1 1 1]/5; 
        s_5.Gaussian = [1 2 4 2 1]/10;
        s_5.EdgeDetecting = [-1/2 -1/2 0 1/2 1/2];
        f.Normalized_Size_5 = s_5;
        f_ = f;
    else
        f = f_;
    end
end