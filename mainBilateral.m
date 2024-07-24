%%
%clear all
clc

tic

closeAll = 1;
ShowInput = 0;
ShowOld = 0;
ShowOutput = 1;
ShowHists = 0;
ShowPlots = 1;
PlotR = 0;

ShrinkFactor = 0.5;

PerformOldAlg = 0;
PostPro = 1;
multipleI0 = 0;

saveResults = 0;

%%

% examed images : 6(foot),8(difficult agan),9(bone),12(lung),13(agan)
SubDirectoryIndexs = 2;
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
        
        N=3;
        
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
        
        [BlurredBilateralPyramid]= LoadBlurredBilateralPyramid(InputMainDirectory,SubDirectoryIndex,Files(ImageIndex).name);

        if(isempty(BlurredBilateralPyramid))
            [BlurredBilateralPyramid]= GenerateBlurredBilateralPyramid(I0,N,1);
            SaveBlurredBilateralPyramid(InputMainDirectory,SubDirectoryIndex,Files(ImageIndex).name,BlurredBilateralPyramid);
        end
        
        %%
        
        [ContrastPyramid]= GenerateContrastBilateralPyramid(BlurredBilateralPyramid,N,1);
        
        BilateralParams;
                
        %SorfPyramid= GenerateSorfPyramid(BlurredBilateralPyramid(1:N),Levels,SorfParams);
        
        SorfPyramid= ContrastPyramid(1:N);
        
        GammaPyrmaid = CalculteGamma(SorfPyramid,GammaParams); 
        
        ResponsePyramid = CalculateResponse(ContrastPyramid,GammaPyrmaid);
        
        F0= CollapseBilateralResponsePyramid(ResponsePyramid);
        
        FinalImage = F0(1:end-padR,1:end-padC);
        
        %%
        if(ShowPlots)
            PlotPyramid(BlurredBilateralPyramid,'BlurredPyramid');
            PlotPyramid(ContrastPyramid,'ContrastPyramid'); 
            PlotPyramid(SorfPyramid,'SorfPyramid');
            PlotPyramid(GammaPyrmaid,'GammaPyrmaid');
            PlotPyramid(ResponsePyramid,'ResponsePyramid');
            
            HistPyramid(SorfPyramid,'SorfPyramid');
        end
        
        %%
        if(multipleI0)
            FinalImage = FinalImage.*IoldAlg;
        end
        FinalImageNorm = FinalImage./max(FinalImage(:));
        
        if(PostPro)
            FinalImageNorm = PostProc(FinalImageNorm,-1.5);
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
            if(PostPro)
                figTitle = [figTitle,' + Post Pro'];
            end
            title(figTitle);
            
%             figure;
%             imshow(FinalImageNormCLAHE,[]);
%             figTitle = [figTitle,' with CLAHE'];
%             title(figTitle);
            
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
            OutputMainDirectory = createOutputDir('..\..\Results');
            OutputDirectory = [OutputMainDirectory,'\',num2str(SubDirectoryIndex)];
            mkdir(OutputDirectory);
            OutputFileName = [OutputDirectory '\' Files(ImageIndex).name,'res'];
            Result =256*(total_contrast_adapthisteq-min(total_contrast_adapthisteq(:)))./(1-min(total_contrast_adapthisteq(:))) ;
            Result = int16(Result);
            info.SOPInstanceUID = dicomuid;
            info.RescaleIntercept = 0;
            info.WindowCenter = 128;
            info.WindowWidth = 256;
            dicomwrite(Result, OutputFileName, info, 'CreateMode', 'copy');
        end
        
        %             figure;
        %             imshow(FinalImageNormCLAHE,[]);
        %             figTitle = ['New + Old Alg'];
        %             title(figTitle);
        
        
    end
end

toc