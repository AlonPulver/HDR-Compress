function SorfPyramid= GenerateSorfPyramidOld(BlurredPyramid,Levels,SorfParams)

N = length(BlurredPyramid);
SorfPyramid = cell(1,N);

for i = 1:N
    StartLevel = SorfParams{i}.start;
    EndLevel = SorfParams{i}.end;
    Sorf = zeros(size(BlurredPyramid{i}));
    for l=StartLevel:EndLevel
        Sorf = Sorf + CenterSeroundAdaptation(BlurredPyramid{i},Levels(l,1),Levels(l,2),Levels(l,3),Levels(l,4),Levels(l,5),Levels(l,6));
    end
    SorfPyramid{i} = Sorf;
end


