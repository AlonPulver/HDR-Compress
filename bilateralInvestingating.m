%%
%clear all
%clc

tic

closeAll = 0;
ShowInput = 0;
ShowOld = 0;
ShowOutput = 1;
ShowHists = 0;
ShowPlots = 0;
PlotR = 0;

ShrinkFactor = 0.5;

PerformOldAlg = 1;
PostPro = 1;
multipleI0 = 0;

saveResults = 0;

%%

% examed images : 6(foot),8(difficult agan),9(bone),12(lung),13(agan)
SubDirectoryIndexs = [3];
InputMainDirectory = '..\..\..\Images\Iris2Anonymized';

for SubDirectoryIndex = SubDirectoryIndexs
    
    InputDirectory = [InputMainDirectory,'\',num2str(SubDirectoryIndex)];
    Files = dir(InputDirectory);
    Files = Files(3:end);
    
    
    if(closeAll)
        close all;
    end
    
    ImageIndexs = 1;%:length(Files);
    for ImageIndex = ImageIndexs
        
        InputFileName = [InputDirectory '\' Files(ImageIndex).name];
        
        
        Ioriginal = dicomread(InputFileName);
        if(length(Ioriginal)==0)
            break;
        end
        info = dicominfo(InputFileName);
        if(info.Modality=='CR')
            Ioriginal =  XrayPreProcessing(Ioriginal);
            if(saveResults)
                saveResults = 0;
                'Not Saving Results'
            end
        end
        
        I0 = imresize(Ioriginal, ShrinkFactor);
        
        I0 = NormAndConvertImagetoDouble(I0);
        
        if(PerformOldAlg)
            
            I0 = GainCOntrolPreProcessing(I0);
        end
        
        BlurredPyramid = cell(1,9);
        
        sigmaD = [1 3 10];
        sigmaR = [0.1 0.3 0.9];
        idx=0;
        for d= sigmaD
            for r = sigmaR
                idx = idx +1;
                BlurredPyramid{idx} = bfilter2(I0,5,[d,r]);
            end
        end
       
        PlotPyramid(BlurredPyramid,'BlurredPyramid');
        
    end
end