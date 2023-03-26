function a = sinusoidal_acc(t)
    A = evalin('base', 'sinusoidal_amplitude');
    w = evalin('base', 'sinusoidal_frequency');
    a = -(2*pi*w)^2*A*sin(2*pi*w*t);