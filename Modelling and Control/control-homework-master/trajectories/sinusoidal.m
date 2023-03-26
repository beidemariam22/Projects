function q = sinusoidal(t)
    A = evalin('base', 'sinusoidal_amplitude');
    w = evalin('base', 'sinusoidal_frequency');
    q = A*sin(2*pi*w*t);