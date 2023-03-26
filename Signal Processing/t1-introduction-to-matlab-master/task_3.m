function [x,is_correct] = task_3()
%% Create matrix and vector
A=[1,2,3; 4,10,6; 7,8,-2];
b=[1,5,8];
%% Concatenation
B=[A; 3 12 -5];
c=[b 6];
%% Least-squares method
x=(B'*B)\B'*c';
is_correct=round((B*x)')==c;
end