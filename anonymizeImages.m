% clear all
% close all
% clc

%anonymize images
InputMainDirectory = '..\..\..\Images\Iris2\';
OutputMainDirectory = '..\..\..\Images\Iris2Anonymized\';
InputSubDirs = dir(InputMainDirectory);
for i=3:size(InputSubDirs)
    inputDir = [InputMainDirectory,InputSubDirs(i).name];
    outputDir = [OutputMainDirectory,InputSubDirs(i).name];
    files = dir(inputDir);
    for j=3:size(files)
        inputFileName = [InputMainDirectory,InputSubDirs(i).name,'\',files(j).name];
        resultFileName = [OutputMainDirectory,InputSubDirs(i).name,'\',files(j).name];
        info = dicominfo(inputFileName);
        Name = [info.PatientName.FamilyName];
        Numbers = Name+1;%Name(1: strfind(Name,'-')-1))+1;
        EncodedName = char(Numbers);
        CheckedName = char(EncodedName-1);
        Id = info.PatientID;
        EncodedId = '';
        Bd = info.PatientBirthDate;
        EncodedBd = '';
        EncodedInfo = info;
        EncodedInfo.PatientName.FamilyName = EncodedName;
        EncodedInfo.PatientID=EncodedId;
        EncodedInfo.PatientBirthDate=EncodedBd;
        dicomwrite(dicomread(inputFileName),resultFileName, EncodedInfo, 'CreateMode', 'copy');
    end
end