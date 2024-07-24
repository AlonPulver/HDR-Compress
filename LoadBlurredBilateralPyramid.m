function [BlurredPyramid]= LoadBlurredBilateralPyramid(InputMainDirectory,SubDirectoryIndex,fileName)

BlurredPyramid = [];

BilateralPyramidPath = [InputMainDirectory,'BilateralPyramid\',num2str(SubDirectoryIndex)];
Files = dir(BilateralPyramidPath);

for i = 3:length(Files)
    savedFileName = Files(i).name;
    idx = strfind(savedFileName, '.');
    if (strcmp(savedFileName(1:idx-1),fileName))
        savedPyramid = load([BilateralPyramidPath,'\',savedFileName]);
        BlurredPyramid = savedPyramid.BlurredBilateralPyramid;
        return;
    end
end