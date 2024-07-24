% Convert Image to double between 0 and 1
% Inputs: Image
% Returns: NewImage and 2 parameters to return the image to previous
% format.
% Author: Solomon Yaniv

function [NewImage,offset,maxValue] = NormAndConvertImagetoDouble(Im)

    offset = double(min(min(Im)));
    NewImage = double(Im) - offset; % if negative it will come to zero and above
    maxValue = max(max(NewImage));
    NewImage = NewImage./maxValue;
