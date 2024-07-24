function [BlurredPyramid]= GenerateBlurredPyramid(I,N,gap)

BlurredPyramid = cell(1,N+gap);

% Generating Blurred Pyramid
BlurredPyramid{1} = I;
for i=2:N+gap
    BlurredPyramid{i} = my_impyramid(BlurredPyramid{i-1} , 'reduce')+1e-9;
end