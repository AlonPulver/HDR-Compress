function PlotPyramidsGraph(xPyramid,yPyramid)

N = length(yPyramid);


lines = ceil(N/3);


figure;

for i = 1:N
    if(i>N)
        break;
    end
    subplot(lines,3,i)
    x = xPyramid{i};
    y = yPyramid{i};
    plot(x(:),y(:),'+');
    axis([0 5 0 1])
end
