function PlotPyramidsGraph1(xPyramid,y1Pyramid,y2Pyramid)

if(nargin<3)
    refY = 0;
else
    refY = 1;
end

N = length(y1Pyramid);
lines = ceil(N/3);

figure('Name', 'Response(Contrast) - Naka');

for i = 1:N
    if(i>N)
        break;
    end
    subplot(lines,3,i)
    %figure;
    x = xPyramid{i};
    y1 = y1Pyramid{i};
    plot(x(:),y1(:),'+');
    if(refY)
        y2 = y2Pyramid{i};
        hold on
        plot(x(:),y2(:),'+r');
        hold off
    end
    %axis([0 5 0 1.1]);
    grid;
end