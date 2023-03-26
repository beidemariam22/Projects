Kb = 0.105; % V/(rad/s)
Km = 0.105; % N*m/A
L = 0.9e-3; % H
R = 0.76; % Ohm
Jm = 6.1e-4; % kg*m^2
Bm = 4e-4; % N*m/(rad/s)
r = 156; % Gear ratio
Vmin = -35; % V
Vmax = 35; % V

B = Bm + (Kb*Km)/R; % Effective damping
disturbance = 0;