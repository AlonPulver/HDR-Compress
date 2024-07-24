function [ output ] = StretchSoft( input )
for (i = 1:size(input, 1))
    for (j = 1:size(input,2))
        I(i,j) = PieceWiseLinear(input(i,j));
    end
end

Levels = [9 27 9 18];
CenterSize = Levels(1);
SrndSize = Levels(2);
CenterSigma = Levels(3);
SrndSigma = Levels(4);
GaussFilterCenter = fspecial('gaussian', CenterSize, CenterSigma);
mask = padarray( ones(size(GaussFilterCenter)),[SrndSize-2*CenterSize SrndSize-2*CenterSize]);
GaussFilterRemote = fspecial('gaussian', SrndSize, SrndSigma).*~mask;
GaussFilterRemote = GaussFilterRemote/sum(GaussFilterRemote(:));
Remote =  imfilter(input,GaussFilterRemote,'replicate');

%Remote = CalculateLocalContrastNewSorf_yael(input,5,6);
output = (input + I.*Remote);
output = Normal(output);
end

function [OutPixel] = PieceWiseLinear(input)
m = 1.3;
if (input < 0.1) 
    OutPixel = input*m;
elseif (input  > 0.9)
    OutPixel = m*(input-1) + 1;
else
    OutPixel = (1-m*0.85)/0.15*(input - 0.5) + 0.5*m;

end
end