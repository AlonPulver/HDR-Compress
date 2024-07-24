function[Param]=LoadInitialParameters
%%FinalGainImage parameters
Param.Rmax=1.5;
Param.alpha=1.6;

%%Beliteral filter
Param.wBlurred=5;
Param.sigmaBlurred=[3,4];

Param.wHyBlurred=30;
Param.sigmaHyBlurred=[7,8];
%% Contrast Image
Param.StartLevelInput=1;
Param.EndLevelInput=6;

Param.StartLevelBlurred=2;
Param.EndLevelBlurred=5;

Param.StartLevelHyBlurred=5;
Param.EndLevelHyBlurred=6;

Param.powerFactor0=1;
Param.powerFactor1=1;
Param.powerFactor2=0.7;
Param.gainFactor0=7;
Param.gainFactor1=35;
Param.gainFactor2=5;

Param.surfPowerFactor0 = 1;
Param.surfPowerFactor1 = 1;
Param.surfPowerFactor2 = 1;
%% Top level statistical normalization
Param.Linearb=0.2;
Param.Lineara=0.3;

%% Ultra level statistical normalization
Param.Lineara_ultra = 0.8;
Param.Linearb_ultra = 0.3;

Param.UltraStatNorm = false;

%% Nirmol each of the images after the beliteral filter
Param.NirmolBlurred = 1;
Param.NirmolHyBlurred = 1;
Param.NirmolInput = 1;

%% Simple normalization factor for final image in the bw area
Param.BWnirmol = 0.27;

%% initial stretch of Input and Blurred
Param.Stretch = false;
Param.StrechBlurred = 0.36;
Param.StrechInput = 2;

%% initial preprocessing
Param.InitialMean = 0.65;
end

