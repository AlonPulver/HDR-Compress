function [SorfPyramid,CenterSrndPyramid]= GenerateSorfPyramid(BlurredPyramid,N,gap)


SorfPyramid = cell(1,N);
CenterSrndPyramid = cell(1,N);

% Generating CenterSrnd Pyramid
for i=1:N
    Ip = BlurredPyramid{i};
    Iexpand = BlurredPyramid{i+gap};
    for g= 1:gap
        Iexpand= (my_impyramid(Iexpand, 'expand'));
    end
    CenterSrnd = abs(Ip - Iexpand).^0.5;
    CenterSrndPyramid{i} = CenterSrnd;
    
end

% Generating Sorf Pyramid

SorfPyramid{N} = CenterSrndPyramid{N};
SorfPyramid{N-1} = CenterSrndPyramid{N-1}+my_impyramid(SorfPyramid{N}, 'expand');

for i=N-2:-1:1
      SorfPyramid{i} = (2/3).*CenterSrndPyramid{i} + (1/6).*(my_impyramid(SorfPyramid{i+1}, 'expand')) + (1/6).*my_impyramid(my_impyramid(SorfPyramid{i+2}, 'expand'),'expand');
end