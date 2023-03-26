function Acc = RMSE(point, Q, DQ, D2Q,Data)
% This Function is the implementation of the Root Mean Squared Error
% Inputs:
%   point - the center point to find the RMSE
%   Q   - an array containing positions in subsequent time instances.
%   DQ  - an array containing velocities in subsequent time instances.
%   D2Q - an array containing accelerations in subsequent time instances.
%   Adams - A Matrix of an Adams Outputs of Position velocity and
%   acceleration
% Outputs:
%   Acc - an array of results of root mean squared error

% indexing
a = ((point -1 )*3)+1;
b = a+1;
c = 1+6*(point-1);

%% Position X
valPosX = 0;

for i=1:size(Data,1)
    valPosX = valPosX + (Data(i,c) - Q(a,i))^2;
end
valPosX = sqrt(valPosX/size(Data,1));

%% Position Y
valPosY = 0;

for i=1:size(Data,1)
    valPosY = valPosY + (Data(i,c+1) - Q(b,i))^2;
end
valPosY = sqrt(valPosY/size(Data,1));

%% Velocity X
valVelX = 0;

for i=1:size(Data,1)
    valVelX = valVelX + (Data(i,c+2) - DQ(a,i))^2;
end
valVelX = sqrt(valVelX/size(Data,1));

%% Velocity Y
valVelY = 0;

for i=1:size(Data,1)
    valVelY = valVelY + (Data(i,c+3) - DQ(b,i))^2;
end
valVelY = sqrt(valVelY/size(Data,1));

%% Acceleration X
valAccX = 0;

for i=1:size(Data,1)
    valAccX = valAccX + (Data(i,c+4) - D2Q(a,i))^2;
end
valAccX = sqrt(valAccX/size(Data,1));

%% Acceleration y
valAccY = 0;

for i=1:size(Data,1)
    valAccY = valAccY + (Data(i,c+5) - D2Q(b,i))^2;
end
valAccY = sqrt(valAccY/size(Data,1));

Acc = [valPosX, valPosY, valVelX, valVelY, valAccX, valAccY];



end


