function q = Newton_Raphson(q0,t)
%   This procedure uses the Newton-Raphson method to solve the set of nonlinear equations.
% In:
%   q0 - the initial approximation,
%   t - the current time instant.
% Out:
%   q - the solution.
%
% The set of nonlinear equations must be defined in Constraints.m.
% The constraint Jacobian must be defined in Jacobian.m.
%

q = q0;

F = Constraints(q,t);

counter = 1; 

while ( (norm(F)>1e-10) && (counter < 25) )
    
    F = Constraints(q,t);
    
    Fq = Jacobian(q);
    
    
    q = q - Fq\F;  % Fq\F solves the linear equation set: Fq*q=F
    
    counter = counter + 1;
 
end

if counter >= 25
    
    disp('ERROR: No convergence after 25 iterations. ');
 
     q = q0;
end



