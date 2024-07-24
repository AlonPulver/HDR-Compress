function [BlurredPyramid, ContrastPyramid]= GenerateEdgePreservingContrastPyramid(I,N,gap)

BlurredPyramid = cell(1,N+gap);

ContrastPyramid = cell(1,N+1);

% Generating Blurred Pyramid
BlurredPyramid{1} = I;
for i=2:N+gap
    BlurredPyramid{i} = myEdgePreservingPyramid(BlurredPyramid{i-1} , 'reduce')+1e-9;
end


% Generating Contrast Pyramid
for i=1:N
    Ip = BlurredPyramid{i};
    Iexpand = BlurredPyramid{i+gap};
    for g= 1:gap
        Iexpand= (myEdgePreservingPyramid(Iexpand, 'expand'))+1e-9;
    end
    C = Ip./ Iexpand;
    C = C./max(C(:));
    ContrastPyramid{i} = C;
%     figure;
%     subplot(1,2,1)
%     imshow(C,[]);
%     subplot(1,2,2)
%     hist(C(:));
end

ContrastPyramid{N+1} = BlurredPyramid{N+1};