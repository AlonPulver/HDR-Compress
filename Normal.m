function [ output ] = Normal( input )
%Normalization of image
input = input - min(input(:));
input = input/max(input(:));
output = input;

    
end

