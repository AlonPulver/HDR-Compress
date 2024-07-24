%%
%clear all
% close all
clear Result;
warning('off', 'Images:initSize:adjustingMag');
clc

tic

closeAll = 0;
ShowInput = 0;
ShowOld = 0;
ShowOutput = 0;
ShowHists = 0;
ShowPlots = 0;
PlotR = 0;

ShrinkFactor = 1;

PerformOldAlg = 0;
PrePro = 0;
OurPrePro = 1;
PostPro = 0;
multipleI0 = 0;


saveCLAHEResults = 0;

Param = LoadInitialParameters;
%%
%PicLocation is the path containing the original HDR files for processing
clc
local = cd;
local = 'E:\CT disks\forHdv';
directoryName = 'biopsy.s28050.s8011';
directoryName='S2790.2010';
directoryName='S56270.S40';
saveResults =1;
n = 16;
saveDicomDirectory = [directoryName,'.Results.contrast.',num2str(n),''];
savePngDirectory = [directoryName,'.Results.contrast.Png.',num2str(n)];
saveCodeDirectory = [directoryName,'.Code.contrast.',num2str(n)];
PicLocation =  fullfile(local, directoryName);

LoadFiles = [];

Files = dir(PicLocation);
% for (i = 1:length(Files)) % there are some file
%     [pathstr, name, ext] = fileparts(Files(i).name);
%     if ~isempty((strfind(Files(i).name, '200')))
%         LoadFiles{end+1} = Files(i); % remove . and .. i.e. dummy files
%     end
% end
%20060627102721565

path = fullfile(local, directoryName);
%Files = LoadFiles;
% Load PNG files.
%local = cd;
fmax = Inf;
a = [1];
b = 1;
if(saveResults)
    l = length(Files);
   
else
    l = 4;
    name ='I2410';
     name ='I1390';
     name = 'I2410';
     name = 'I1110';
   
end


minOfMaxValue = Inf;
for ImageIndex = 4:l       
     
        name =  Files(ImageIndex).name;%'I1370';%
        
        Ioriginal = dicomread(fullfile(local, directoryName, name));
        
        maxValue = max(Ioriginal(:));
       
        if(minOfMaxValue > maxValue)
            minOfMaxValue = maxValue;
            
        end
 end

    for ImageIndex = 4:l
       
        if(saveResults)
            name =  Files(ImageIndex).name;%'I1370';%
        end
        Ioriginal = dicomread(fullfile(local, directoryName, name));
        Ioriginal =    min(Ioriginal,minOfMaxValue);
        Imax = max(Ioriginal(:));
        info = dicominfo(fullfile(local, directoryName, name));
        
        I0 = (imresize(Ioriginal(:,:,1), ShrinkFactor));
       
        %I0(I0>=2317)=2317;
       %[ Ip ] = SoftTissues( I0 );
       [M,Ilung,Ibone] = modulation(I0);
       M = 1-M;
       IBone = modulationBone(I0);
       I0 = NormAndConvertImagetoDouble(I0);
       %  Ioriginal =I0;
       
         
        if(ShowInput)
%             figure;
%             imshow(I0,[]);
%             title('Original Image ');
            
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
        if (OurPrePro)
            I0(1,1) = 0; % over exposed pixels 
             I0 = I0 - I0(1, end/2); % remove air
             I0(I0 < 0) = 0;
            % I0 = Normal(I0);
             
               %I0 = StretchSoft(I0, Param);
             I0 = StretchSoft_fromHadar(I0, Imax);
              I0(I0 < 0) = 0;
        end
        if(PrePro)
              I0 = GainExp(I0,-2);
        end
        %%
        
        I0(imag(I0) ~= 0) = real(I0(imag(I0) ~= 0));
        %I0(I0 <0 ) = 1e-9;
        %%
        
       
        
        
        %%
        
        N=7;
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
         Iorg = padarray(NormAndConvertImagetoDouble(Ioriginal),[padR padC],'post');
        
        [BlurredPyramid]= GenerateBlurredPyramid(I0,N,gap);
       %[BlurredPyramid1]= GenerateBlurredPyramid(I1,N,gap);
        
        [ModulationPyramid]= GenerateBlurredPyramid(M,N,gap);
       % [IbonePyramid]= GenerateBlurredPyramid(Ibone,N,gap);
        
        [ContrastPyramid]= GenerateContrastPyramid(BlurredPyramid,N,gap);
        
        Params;
        
        [SorfPyramid,CenterSrndPyramid]=  GenerateSorfPyramid(BlurredPyramid,N,gap);
        
        GammaPyrmaid = CalculteGamma(SorfPyramid,GammaParams,ContrastPyramid,ModulationPyramid);
        
        ResponsePyramid = CalculateResponse(ContrastPyramid,GammaPyrmaid,ModulationPyramid);
        [InverseContrastPyramid,ReferenceResponsePyramid] = CalculateResponseWithInverse(ContrastPyramid,GammaPyrmaid,20);
        
        F0= CollapseResponsePyramid(ResponsePyramid,ContrastPyramid);
        [max(F0(:)) min(F0(:))]
        %F1 = CollapseResponsePyramidInv(InverseContrastPyramid);
        %imtool(F1,[]);
        %F1= CollapseResponsePyramid(InverseContrastPyramid,ContrastPyramid);
        
        FinalImage = F0(1:end-padR,1:end-padC);
       % COMPUTE STATISTICS (FIRST FRAME)
    if (ImageIndex==5)
        
        % COMPUTE STATISTICS FOR NEXT ITERATION
        meanBeforeHDR(1) = mean2(Ioriginal);
        stdBeforeHDR(1)  = std2(Ioriginal);
        meanAfterHDR     = mean2(FinalImage);
        stdAfterHDR      = std2(FinalImage);
        
    end
    
    % GLOBAL CONTRAST AND GAIN CORRECTION FOR HDR OUTPUT (AFTER FIRST FRAME)
    if (ImageIndex>5)
        
        % COMPUTE STATISTICS
        meanBeforeHDR(2) = mean2(Ioriginal);
        stdBeforeHDR(2)  = std2(Ioriginal);
        % COMPUTE RATIOS
        targetMeanRatio = meanBeforeHDR(2)/(meanBeforeHDR(1)+eps);
        targetStdRatio  = stdBeforeHDR(2)/(stdBeforeHDR(1)+eps);
        % COMPUTE TARGET STATISTICS FOR CURRENT HDR FRAME
        % (meanAfterHDR and stdAfterHDR were computed in the previous time step)
        targetMean = meanAfterHDR*targetMeanRatio;
        targetStd  = stdAfterHDR*targetStdRatio;
        % TRANSFORM CONTRAST AND GAIN FOR CURRENT HDR FRAME
        FinalImage = transformMeanStd(FinalImage,targetMean,targetStd);
        % UPDATE HDR STATISTICS FOR NEXT ITERATION
        meanAfterHDR     = mean2(FinalImage);
        stdAfterHDR      = std2(FinalImage);
        meanBeforeHDR(1) = meanBeforeHDR(2);
        stdBeforeHDR(1)  = stdBeforeHDR(2);
        
    end
        if(~saveResults)
            imtool(FinalImage,[]);
        end
        
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
        
       
       
        %FinalImage = min(FinalImage,0.0728);
        s = struct('name',name,'Result',FinalImage,'info',info,'max',max(FinalImage(:)));
        Result(ImageIndex-3) = s;
        %FinalImage = min(FinalImage,0.0717);%min(FinalImage,0.05);
        %FinalImageNorm = FinalImage./max(FinalImage(:));
        %FinalImageNorm = FinalImage./0.0717;
        
        if(PostPro)
            % FinalImageNorm = GainExp(FinalImageNorm,-1.5);
            % FinalImageNorm = GainExp(FinalImageNorm,-2.5);
            FinalImageNorm = GainExp(FinalImageNorm,-3);
        end
        
        %%
        
%         FinalImageNormCLAHE = adapthisteq(FinalImageNorm,'Distribution','uniform');
        
       
        
        %%
        
%         if(saveResults)
%             %FinalImageNorm(imag(FinalImageNorm) ~= 0) = real(FinalImageNorm(imag(FinalImageNorm) ~= 0));
%             %FinalImageNorm(FinalImageNorm <0 ) = 1e-9;
%             OutputDirectoryPng = fullfile(local, savePngDirectory);
%             mkdir(OutputDirectoryPng);
%             OutputFileName = [OutputDirectoryPng '\' Files(ImageIndex).name];
%             Result = 256*(FinalImageNorm);
%             imwrite(uint8(Result),strcat(OutputFileName,'.png') , 'png');
%             Result = int16(Result);
%             info.SOPInstanceUID = dicomuid;
%             info.RescaleIntercept = 0;
%             info.WindowCenter = 146;
%             info.WindowWidth = 256;
%             %Result(imag(Result)) = real(Result);
%             OutputDirectory = fullfile(local, saveDicomDirectory);
%             mkdir(OutputDirectory);
%             OutputFileName = [OutputDirectory '\' Files(ImageIndex).name];
%             dicomwrite(Result, OutputFileName, info, 'CreateMode', 'copy');
%             %imwrite(Result, OutputFileName, 'png');
%             
%            
%         end
        
        
        
        %             figure;
        %             imshow(FinalImageNormCLAHE,[]);
        %             figTitle = ['New + Old Alg'];
        %             title(figTitle);
        
        
    end
  toc  
  
        if(saveResults)
            fmax = max([Result.max]);
            fmedian = median([Result.max]);
%             fmax = 0;
%             for j = 1: size(Result,2)
%                 FinalImage = Result(j).Result;
%                 if( fmax < max(FinalImage(:)))
%                     fmax = max(FinalImage(:));                    
%                 end
%             end
            
            
            for i = 1 : size(Result,2)
                %FinalImageNorm(imag(FinalImageNorm) ~= 0) = real(FinalImageNorm(imag(FinalImageNorm) ~= 0));
                %FinalImageNorm(FinalImageNorm <0 ) = 1e-9;
                FinalImage = Result(i).Result;
                FinalImage = min(FinalImage,fmedian);%min(FinalImage,0.05);
                %FinalImageNorm = FinalImage./max(FinalImage(:));
                FinalImageNorm = FinalImage./fmedian;
                
                OutputDirectoryPng = fullfile(local, savePngDirectory);
                mkdir(OutputDirectoryPng);
                OutputFileName = [OutputDirectoryPng '\' Result(i).name];
                Result_image = 256*(FinalImageNorm);
                imwrite(uint8(Result_image),strcat(OutputFileName,'.png') , 'png');
                Result_image = int16(Result_image);
                info_image = Result(i).info; 
                info_image.SOPInstanceUID = dicomuid;
                info_image.RescaleIntercept = 0;
                info_image.WindowCenter = 128;
                info_image.WindowWidth = 256;
                %Result(imag(Result)) = real(Result);
                OutputDirectory = fullfile(local, saveDicomDirectory);
                mkdir(OutputDirectory);
                OutputFileName = [OutputDirectory '\' Result(i).name];
                dicomwrite(Result_image, OutputFileName, info_image, 'CreateMode', 'copy');
                %imwrite(Result, OutputFileName, 'png');
            end
            
           
        end
  
    if(saveResults)
         OutputCodeDirectory = fullfile(local, saveCodeDirectory);
           codepath = cd;
           copyfile(codepath,OutputCodeDirectory,'f');

    end
    
    



