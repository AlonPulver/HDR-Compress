function ResponsePyramid = CalculateResponse2(ContrastPyrmaid,GammaPyrmaid)

Rmax = 0.7;
alpha = 1;
b=0;
beta = 1;


N = length(ContrastPyrmaid)-1;
ResponsePyramid = cell(1,N);

for i = 1:N
    C = ContrastPyrmaid{i};
    Gamma = GammaPyrmaid{i};
    R = zeros(size(C));
    %R = Rmax./(alpha + ((beta./C).^(Gamma)))+b;
    R(C>=1) = Rmax./(alpha + ((beta./C(C>=1)).^(Gamma(C>=1))))+b;
    R(C<1) = Rmax./(alpha + ((beta*C(C<1)).^(1./Gamma(C<1))))+b;
    ResponsePyramid{i} = R;
end
