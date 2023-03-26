models = dir([pwd '/*.slx']);
model_names = {models.name};
for n=1:length(model_names)
    name = model_names{n};
    open_system(name);
    print('-dpng', '-s', [pwd '/report/' name '.png']);
    close_system
end