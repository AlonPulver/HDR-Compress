function outputDir = createOutputDir(Path)
fullName = [pwd,'-',date];
sleshIndex = strfind(fullName,'\');
croppedName = fullName(sleshIndex(end):end);
outputDir = [Path,croppedName];
mkdir(outputDir);