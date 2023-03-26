clear; clc;
%% Task 1
% Vector initialization
v1=linspace(0,1,10);
v2=linspace(1,2,10);
% Element-per-element product
element_product=v1.*v2
% Dot product
dot_product=v1*v2'
% Cross product
cross_product=cross(v1(1:3),v2(1:3))
%% Task 2
% Create matrix and vector
A=[1,2,3; 4,10,6; 7,8,-2];
b=[1,5,8];
% Solve system Ax=b'
x=linsolve(A,b')
is_correct=round((A*x)')==b
%% Task 3
% Concatenation
B=[A; 3 12 -5]
c=[b 6]
% Least-squares method
x=(B'*B)\B'*c'
is_correct=round((B*x)')==c