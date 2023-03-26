function [x,is_correct] = task_2()
%% Create matrix and vector
A=[1,2,3; 4,10,6; 7,8,-2];
b=[1,5,8];
%% Solve system Ax=b'
x=linsolve(A,b');
is_correct=round((A*x)')==b;
end