function B = myEdgePreservingPyramid(A, direction)

iptcheckinput(A, {'numeric', 'logical'}, {}, mfilename, 'A', 1);
direction = iptcheckstrs(direction, {'reduce', 'expand'}, ...
    mfilename, 'DIRECTION', 2);

M = size(A,1);
N = size(A,2);

A = NormAndConvertImagetoDouble(A);

if strcmp(direction, 'reduce')
    scaleFactor = 0.5;
    outputSize = ceil([M N]/2);
    G = bfilter2(A,5,[0.5,0.3]);
    B = imresize(G, scaleFactor, ...
    'OutputSize', outputSize, 'Antialiasing', false);
else
    scaleFactor = 2;
    outputSize = 2*[M N];
    kernel = makePiecewiseConstantFunction( ...
        [1.25   0.75    0.25   -0.25   -0.75   -1.25   -Inf], ...
        [0.0    0.125   0.5     0.75    0.5    0.125    0.0]);
    kernelWidth = 3;
    B = imresize(A, scaleFactor, {kernel, kernelWidth}, ...
    'OutputSize', outputSize, 'Antialiasing', false);

end

end

function fun = makePiecewiseConstantFunction(breakPoints, values)
% Constructs a piecewise constant function and returns a handle to it.
%
% breakPoints and values have to be vectors with the same number of
% elements.
%
% The elements in breakPoints have to be monotonically decreasing.
% 
% fun(x) returns values(1) if x >= breakPoints(1)
%
% else fun(x) returns values(2) if x >= breakPoints(2)
%
% else fun(x) returns values(3) if x >= breakPoints(3)
%
% etc.
%
% If x is less than breakPoint(end), then fun returns 0.
%
% If x is an array, then fun operates elementwise on x and returns an array
% of the same size.

assert(all(diff(breakPoints) < 0), ...
    'Images:impyramid:badBreakPointList', ...
    'breakPoints must be monotonically decreasing.');

fun = @piecewiseConstantFunction;

    function y = piecewiseConstantFunction(x)
        y = zeros(size(x));
        for k = 1:numel(x)
            yy = 0;
            xx = x(k);
            for p = 1:numel(breakPoints)
                if xx >= breakPoints(p)
                    yy = values(p);
                    break;
                end
            end
            y(k) = yy;
        end
    end
end