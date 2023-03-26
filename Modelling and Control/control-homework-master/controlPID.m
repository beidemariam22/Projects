w = 18;
Kp = 3*(w^2*Jm*R)/Km;
Kd = R*(3*w*Jm-B)/Km;
Ki = (Jm*R*w^3)/Km;

sinusoidal_frequency = w/5; % rad/s To be correcte after calculating the control