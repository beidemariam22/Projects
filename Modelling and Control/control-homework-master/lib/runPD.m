function [q, qd, v, vd, eq] = runPD()
    simout = sim('PD');
    qd = get(simout.yout, 'position_ref');
    eq = get(simout.yout, 'error_position');
    q = get(simout.yout, 'position');
    vd = get(simout.yout, 'velocity_ref');
    v = get(simout.yout, 'velocity');