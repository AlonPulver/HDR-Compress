for i = 1 : size(Result,2)
                %FinalImageNorm(imag(FinalImageNorm) ~= 0) = real(FinalImageNorm(imag(FinalImageNorm) ~= 0));
                %FinalImageNorm(FinalImageNorm <0 ) = 1e-9;
                FinalImage = Result(i).Result
                FinalImage = min(FinalImage,fmax);%min(FinalImage,0.05);
                %FinalImageNorm = FinalImage./max(FinalImage(:));
                FinalImageNorm = FinalImage./fmax;
                
                OutputDirectoryPng = fullfile(local, savePngDirectory);
                mkdir(OutputDirectoryPng);
                OutputFileName = [OutputDirectoryPng '\' Result(i).name];
                Result = 256*(FinalImageNorm);
                imwrite(uint8(Result),strcat(OutputFileName,'.png') , 'png');
                Result = int16(Result);
                info.SOPInstanceUID = dicomuid;
                info.RescaleIntercept = 0;
                info.WindowCenter = 146;
                info.WindowWidth = 256;
                %Result(imag(Result)) = real(Result);
                OutputDirectory = fullfile(local, saveDicomDirectory);
                mkdir(OutputDirectory);
                OutputFileName = [OutputDirectory '\' Files(ImageIndex).name];
                dicomwrite(Result, OutputFileName, info, 'CreateMode', 'copy');
                %imwrite(Result, OutputFileName, 'png');
end