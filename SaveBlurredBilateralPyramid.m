function SaveBlurredBilateralPyramid(InputMainDirectory,SubDirectoryIndex,fileName,BlurredBilateralPyramid)

BilateralPyramidPath = [InputMainDirectory,'BilateralPyramid\',num2str(SubDirectoryIndex)];
mkdir(BilateralPyramidPath);
FullFileName = [BilateralPyramidPath,'\',fileName];
save(FullFileName, 'BlurredBilateralPyramid');