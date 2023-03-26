function result = task_3(A, plot_result)
    if ~exist("plot_result", "var")
        plot_result = false;
    end
    r_conv = task_2(A, false);
    r_myconv = task_2(A, false, @myconv);
    if plot_result 
        figure(3)
        clf
        plots = {};
        categories = fieldnames(r_myconv);
        c_N = numel(categories);
        for c = 1:c_N
            c_name = categories{c};
            category_ = r_myconv.(c_name);
            kernels = fieldnames(category_);
            k_N = numel(kernels);
            for k = 1:k_N
                k_name = kernels{k};
                C_myconv = category_.(k_name);
                C_conv = r_conv.(c_name).(k_name);
                % Plot both results in same figure
                plots = plot_convolution( ... 
                    k_name, [c_name '_myconv'], C_myconv, A, plots ...
                    );
                plots = plot_convolution(k_name, c_name, C_conv, A, plots);
                % Plot difference
                plots = plot_convolution( ... 
                    'Difference', [k_name ': ' c_name ], ... 
                    C_myconv-C_conv, A, plots ...
                    );
            end
        end
    end

    function plots = plot_convolution(k_name, c_name, C, A, plots)
        if isempty(plots)
            plots = {};
        end
        if ~isfield(plots, k_name)
            plots.(k_name).ax = nexttile();
            if ~strcmp(k_name, 'Difference')
                plot(A, "DisplayName", "Original")
            end
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