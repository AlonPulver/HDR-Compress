function [InverseContrastPyramid,ReferenceResponsePyramid] = CalculateResponseWithInverse(ContrastPyrmaid,GammaPyrmaid,GammaReference)

Rmax = 1;
alpha = 1;
b=0;
beta = 1;


N = length(ContrastPyrmaid)-1;
InverseContrastPyramid = cell(1,N);
ReferenceResponsePyramid = cell(1,N);

for i = 1:N
    C = ContrastPyrmaid{i};
    Gamma = GammaPyrmaid{i};
    %R = Rmax./(alpha + ((beta./C).^(Gamma)))+b;
    %ResponsePyramid{i} = R;
    
    ReferenceResponse = Rmax./(alpha + ((beta./C).^(GammaReference)))+b;
    ReferenceResponsePyramid{i} = ReferenceResponse;
    
    Cinv = C.^(Gamma./GammaReference);
    
    
    InverseContrastPyramid{i} = Cinv;
    
end
