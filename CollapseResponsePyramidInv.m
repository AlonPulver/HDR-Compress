function F = CollapseResponsePyramidInv(InvResponsePyramid)

N = length(InvResponsePyramid)-1;

F = InvResponsePyramid{N}.*my_impyramid(InvResponsePyramid{N+1}, 'expand');
for i = N-1:-1:1
    F = InvResponsePyramid{i}.*my_impyramid(F, 'expand');
end