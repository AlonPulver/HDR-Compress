function [ output ] = StretchSoft_fromHadar( input, Param, a, b )
W = zeros(size(input));
for (i = 1:size(input, 1))
    for (j = 1:size(input,2))
        W(i,j) = PieceWiseLinear(input(i,j), max(input(:)));
%         W(i,j) = SineStretch(input(i,j),a,b );
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
Remote5 = Remote.^5;
%Remote = CalculateLocalContrastNewSorf_yael(input,5,6);

output = (input + 11*W.*Remote5/max(Remote(:)));
output = Normal(output);
end

