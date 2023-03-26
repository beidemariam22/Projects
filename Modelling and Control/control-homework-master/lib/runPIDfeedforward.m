function [q, qd, v, vd, eq] = runPIDfeedforward()
    simout = sim('PIDfeedforward');
    qd = get(simout.yout, 'position_ref');
    eq = get(simout.yout, 'error_position');
    q = get(simout.yout, 'position');
    vd = get(simout.yout, 'velocity_ref');
    v = get(simout.yout, 'velocity');