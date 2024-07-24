function HistPyramid(Pyramid,t)

N = length(Pyramid);


lines = ceil(N/3);


figure;

for i = 1:N
    if(i>N)
        break;
    end
    subplot(lines,3,i)
    I = Pyramid{i};
    hist(I(:));
    if(i==1)
       title(t);
    end
end
