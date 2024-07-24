%%
%clear all
clc

tic

closeAll = 0;
ShowInput = 1;
ShowOld = 0;
ShowOutput = 1;
ShowHists = 0;
ShowPlots = 0;
PlotR = 0;

ShrinkFactor = 1;

PerformOldAlg = 0;
PrePro = 1;
PostPro = 1;
multipleI0 = 0;

saveResults = 0;
saveCLAHEResults = 0;

%%

% examed images series 1 : 6(foot),8(difficult agan),9(bone),12(lung),13(agan)
SubDirectoryIndexs = [2];

InputMainDirectory = '..\..\..\Images\ForHistEq';

for SubDirectoryIndex = SubDirectoryIndexs
    
    InputDirectory = [InputMainDirectory,'\',num2str(SubDirectoryIndex)];
    Files = dir(InputDirectory);
    Files = Files(3:end);
    
    if(closeAll)
        close all;
    end
    
    ImageIndexs = 1;%:length(Files);
    for ImageIndex = ImageIndexs
        
        InputFileName = [InputMainDirectory '\house.jpg'];
        
        
        %Ioriginal = dicomread('mri.dcm');
        Ioriginal = imread(InputFileName);
        %Ioriginal = imread('mandi.tif');

        
        I0 = imresize(Ioriginal(:,:,1), ShrinkFactor);
        
        %%
        
         I0 = NormAndConvertImagetoDouble(I0);
         Ioriginal =I0;
         
        if(ShowInput)
            figure;
            imshow(I0,[]);
            title('Original Image ');
            
            figure;
            I0CLAHE = adapthisteq(I0,'Distribution','exponential');
            imshow(I0CLAHE,[]);
            title('Original Image + CLAHE ');
            
            if(ShowHists)
                figure;
                hist(I0(:));
                title('Original Image');
                
                figure;
                hist(I0CLAHE(:));
                title('Original Image + CLAHE ');
            end
        end
         
%         if(PrePro)
%             I0 = GainExp(I0,-3);
%         end
        
        if(PrePro)
            I0 = GainExp(I0,-0.8);
        end
              
        %%
        
        if(PerformOldAlg)
            
            IoldAlg = GainCOntrolPreProcessing(I0);
            
            I0CLAHE = adapthisteq(IoldAlg,'Distribution','exponential');
            
            I0 =  IoldAlg;
            
            if(ShowOld)
                figure;
                imshow(I0,[]);
                title('Old Alg');
                
                figure;
                imshow(I0CLAHE);
                title('Old Alg with CLAHE');
                
                if(ShowHists)
                    figure;
                    hist(I0(:));
                    title('Old Alg');
                    
                    figure;
                    hist(I0CLAHE(:));
                    title('Old Alg with CLAHE');
                end
            end
        end
        
        
        %%
        
        N=5;
        gap = 1;
        
        padFactor = 2^(N+1);
        [r,c] = size(I0);
        padR = 0;
        padC = 0;
        if(mod(r,padFactor)~=0)
            padR = padFactor - mod(r,padFactor);
        end
        if(mod(c,padFactor)~=0)
            padC = padFactor - mod(c,padFactor);
        end
        
        I0 = padarray(I0,[padR padC],'post');
        
        [BlurredPyramid]= GenerateBlurredPyramid(I0,N,gap);
        
        [ContrastPyramid]= GenerateContrastPyramid(BlurredPyramid,N,gap);
        
        Params;
        
        [SorfPyramid,CenterSrndPyramid]=  GenerateSorfPyramid(BlurredPyramid,N,gap);
        
        GammaPyrmaid = CalculteGamma(SorfPyramid,GammaParams);
        
        ResponsePyramid = CalculateResponse(ContrastPyramid,GammaPyrmaid);
        
        F0= CollapseResponsePyramid(ResponsePyramid,ContrastPyramid);
        
        FinalImage = F0(1:end-padR,1:end-padC);
        
        
        %%
        if(ShowPlots)
            PlotPyramid(BlurredPyramid,'BlurredPyramid');
            PlotPyramid(ContrastPyramid,'ContrastPyramid');
            PlotPyramid(SorfPyramid,'SorfPyramid');
            PlotPyramid(GammaPyrmaid,'GammaPyrmaid');
            PlotPyramid(ResponsePyramid,'ResponsePyramid');
            
            HistPyramid(SorfPyramid,'SorfPyramid');
            HistPyramid(GammaPyrmaid,'GammaPyrmaid');
            %             HistPyramid(ContrastPyramid,'ContrastPyramid');
            
            PlotPyramidsGraph(ContrastPyramid,ResponsePyramid);
        end
        
        %%
        if(multipleI0)
            FinalImage = FinalImage.*IoldAlg;
        end
        FinalImageNorm = FinalImage./max(FinalImage(:));
        
        if(PostPro)
            FinalImageNorm = GainExp(FinalImageNorm,-1.1);
            %FinalImageNorm = GainExp(FinalImageNorm,-5);
        end
        
        %%
        
        FinalImageNormCLAHE = adapthisteq(FinalImageNorm,'Distribution','uniform');
        
        if(ShowOutput)
            figure;
            imshow(FinalImageNorm);
            figTitle = 'New Alg';
            if(PerformOldAlg)
                figTitle = [figTitle,' + Old Alg'];
            end
            if(multipleI0)
                figTitle = [figTitle,' + Multiple I0'];
            end
            if(PrePro)
                figTitle = [figTitle,' + PrePro'];
            end
            if(PostPro)
                figTitle = [figTitle,' + PostPro'];
            end
            title(figTitle);
            
%                         figure;
%                         imshow(FinalImageNormCLAHE,[]);
%                         figTitle = [figTitle,' with CLAHE'];
%                         title(figTitle);
            
            if(ShowHists)
                figure;
                hist(FinalImageNorm(:));
                title(figTitle);
                
                figure;
                hist(FinalImageNormCLAHE(:));
                title(figTitle);
            end
        end
        
        %%
        
        if(saveResults)
            OutputMainDirectory = createOutputDir('..\..\..\Results');
            OutputDirectory = [OutputMainDirectory,'\',num2str(SubDirectoryIndex)];
            mkdir(OutputDirectory);
            OutputFileName = [OutputDirectory '\' Files(ImageIndex).name,'res'];
            Result = 256*NormAndConvertImagetoDouble(FinalImageNorm);
            Result = int16(Result);
            info.SOPInstanceUID = dicomuid;
            info.RescaleIntercept = 0;
            %info.WindowCenter = 128;
            %info.WindowWidth = 256;
            dicomwrite(Result, OutputFileName, info, 'CreateMode', 'copy');
        end
        
        if(saveCLAHEResults)
            OutputMainDirectory = createOutputDir('..\..\..\CLAHEResults');
            OutputDirectory = [OutputMainDirectory,'\',num2str(SubDirectoryIndex)];
            mkdir(OutputDirectory);
            OutputFileName = [OutputDirectory '\' Files(ImageIndex).name,'res'];
            Result = 256*NormAndConvertImagetoDouble(I0CLAHE);
            Result = int16(Result);
            info.SOPInstanceUID = dicomuid;
            info.RescaleIntercept = 0;
            %info.WindowCenter = 128;
            %info.WindowWidth = 256;
            dicomwrite(Result, OutputFileName, info, 'CreateMode', 'copy');
        end
        
        %             figure;
        %             imshow(FinalImageNormCLAHE,[]);
        %             figTitle = ['New + Old Alg'];
        %             title(figTitle);
        
        
    end
end

toc