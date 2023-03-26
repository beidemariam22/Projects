function BW = createMask(RGB)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder app. The colorspace and
%  range for each channel of the colorspace were set within the app. The
%  segmentation mask is returned in BW, and a composite of the mask and
%  original RGB images is returned in maskedRGBImage.

% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Orange ------------------------------------------------------

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.970;
channel1Max = 0.051;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.297;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.192;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Green ------------------------------------------------------

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.225;
channel1Max = 0.311;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.313;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.141;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW | BW; % Combine pasts masks

end
