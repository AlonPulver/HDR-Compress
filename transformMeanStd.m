function output = transformMeanStd(input, targetMEAN, targetSTD)

% THIS FUNCTION TRANSFORMS THE MEAN AND STANDARD DEVIATION OF THE INPUT
% MATRIX ELEMENTS TO FIT A REQUIRED MEAN AND STD.
%
% - YEHUDA

originalMEAN = mean2(input);
originalSTD  = std2(input);
ratioSTD = targetSTD/(originalSTD+eps);
output = input*ratioSTD + targetMEAN - originalMEAN*ratioSTD;

end