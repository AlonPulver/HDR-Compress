function [ output ] = StatisticalNorm(Mask, input, Param)
I = input;
%original - kinda worked
I = input - mean(input(Mask));
I = I/sqrt(var(I(Mask)));
I = sqrt(Param.Linearb)*I;
%I = I + Param.Lineara*mean(input(Mask));
I = I + Param.Lineara;
output = I;
%output = I - I(256,2);


% according to different areas
% I(Mask) = input(Mask) - mean(input(Mask));
% I(Mask) = I(Mask)/sqrt(var(I(Mask)));
% I(Mask) = sqrt(Param.Linearb)*I(Mask);
% I(Mask) = I(Mask) + Param.Lineara*mean(input(Mask));
% output = I - I(256,2);



%output = output*0.8;
end
