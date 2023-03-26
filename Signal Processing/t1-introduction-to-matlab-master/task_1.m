function [element_product,dot_product,cross_product] = task_1()
%% Vector initialization
v1=linspace(0,1,10);
v2=linspace(1,2,10);
%% Element-per-element product
element_product=v1.*v2;
%% Dot product
dot_product=v1*v2';
%% Cross product
cross_product=cross(v1(1:3),v2(1:3));
end