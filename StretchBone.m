function [ output ] = StretchBone( input, Param )
for (i = 1:size(input, 1))
    for (j = 1:size(input,2))
        I(i,j) = PieceWiseLinear(input(i,j));
    end
end
% 
% Levels = [9 27 9 18];
% CenterSize = Levels(1);
% SrndSize = Levels(2);
% CenterSigma = Levels(3);
% SrndSigma = Levels(4);
% GaussFilterCenter = fspecial('gaussian', CenterSize, CenterSigma);
% mask = padarray( ones(size(GaussFilterCenter)),[SrndSize-2*CenterSize SrndSize-2*CenterSize]);
% GaussFilterRemote = fspecial('gaussian', SrndSize, SrndSigma).*~mask;
% GaussFilterRemote = GaussFilterRemote/sum(GaussFilterRemote(:));
% Remote =  imfilter(input,GaussFilterRemote,'replicate');
% 
% %Remote = CalculateLocalContrastNewSorf_yael(input,5,6);
% output = (input + I.*Remote);
% output = Normal(output);
output = I;
end

function [OutPixel] = PieceWiseLinear(input)
m = 0.1;
V = 0.4;
M = (1-m*V)/(1-V);
if (input < V) 
    OutPixel = input*m;
else
   
    OutPixel = 1 - M*(1-input); 

end
end