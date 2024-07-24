function F = CollapseResponsePyramid(ResponsePyramid,ContrastPyrmaid)

N = length(ResponsePyramid);

F = ResponsePyramid{N}.*my_impyramid(ContrastPyrmaid{N+1}, 'expand');
F = Normal(F);
for i = N-1:-1:1
    F = ResponsePyramid{i}.*my_impyramid(F, 'expand');  
    %F = Normal(F);
end