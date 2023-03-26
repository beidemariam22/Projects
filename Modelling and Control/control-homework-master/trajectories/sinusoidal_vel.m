function v = sinusoidal_vel(t)
    A = evalin('base', 'sinusoidal_amplitude');
    w = evalin('base', 'sinusoidal_frequency');
    v = 2*pi*w*A*cos(2*pi*w*t);