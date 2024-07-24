function [ContrastPyramid]= GenerateContrastBilateralPyramid(BlurredPyramid,N,gap)

ContrastPyramid = cell(1,N+1);

% Generating Contrast Pyramid
for i=1:N
    I1 = BlurredPyramid{i};
    I2 = BlurredPyramid{i+gap}+1e-9;
    C = I1./ I2;
    ContrastPyramid{i} = C;
%     figure;
%     subplot(1,2,1)
%     imshow(C,[]);
%     subplot(1,2,2)
%     hist(C(:));
end