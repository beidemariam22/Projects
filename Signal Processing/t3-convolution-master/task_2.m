% Create three simple filters with a size of [1x3]:
%     F1 - averaging filter [1/3 1/3 1/3]
%     F2 - Gaussian filter [1/4 1/2 1/4]
%     F3 - edge-detecting filter [-1 0 1]
% Convolve input signal A with each of the filters.
function result = task_2(A, plot_result, conv_function)
    if ~exist("plot_result", "var")
        plot_result = false;
    end
    if ~exist("conv_function", "var")
        conv_function = @conv;
    end
    if plot_result
        figure(2)
        plots = {};
        clf
    end
    result = {};
    f = filters;
    categories = fieldnames(f);
    c_N = numel(categories);
    for c = 1:c_N
        c_name = categories{c};
        category_ = f.(c_name);
        filter_kernels = fieldnames(category_);
        k_N = numel(filter_kernels);
        for k = 1:k_N
            k_name = filter_kernels{k};
            kernel = category_.(k_name);
            C = conv_function(A, kernel);
            result.(c_name).(k_name) = C;
            if plot_result 
                plots = plot_convolution(k_name, c_name, C, A, plots);
            end
        end
    end

    function plots = plot_convolution(k_name, c_name, C, A, plots)
        if isempty(plots)
            plots = {};
        end
        if ~isfield(plots, k_name)
            plots.(k_name).ax = nexttile();
            plot(A, "DisplayName", "Original")
            title(sprintf("%s", ... 
                strrep(k_name,'_',' ') ... 
                ))
            ylim([-1.5,1.5])
            xlim([0, length(A)])
            % Zoom
            % ylim([0.85,1.2])
            % xlim([224, 242])
            hold on
        end
        ax = plots.(k_name).ax;
        plot(ax, C, "DisplayName", strrep(c_name,'_',' '))
        legend
    end
end