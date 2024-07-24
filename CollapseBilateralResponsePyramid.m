function F = CollapseBilateralResponsePyramid(ResponsePyramid)

N = length(ResponsePyramid);

F = ResponsePyramid{N};
for i = N-1:-1:1
    F = ResponsePyramid{i}.*F;
end