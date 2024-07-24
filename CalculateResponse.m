function ResponsePyramid = CalculateResponse(ContrastPyrmaid,GammaPyrmaid,ModulationPyramid)

Rmax = 1;
alpha = 1;
b=0;
beta = 1;


N = length(ContrastPyrmaid)-1;
ResponsePyramid = cell(1,N);

for i = 1:N
    C = ContrastPyrmaid{i};
    X = GammaPyrmaid{i};
    M= ModulationPyramid{i};%(my_impyramid(ModulationPyramid{i+1}, 'expand'));
    Gamma = X.^(((1-M).^0.3).*(M).^0.8);  
    nC = 1;
    if(i >7)
        Gamma = X.^(((1-M).^0.7).*(M).^0.6); 
        %M = ModulationPyramid{i};
        M = M./max(M(:));
        % A = ((1-M)-0.5).^2;
        A = M;
        
        Rmax = (1-A./(i).^2);
    
 %Gamma = X.^0.5;
    elseif( i == 3 || i == 4)
       nC = C - my_impyramid(ContrastPyrmaid{i+1}, 'expand');
        l1 = 0.1;
        l2 = 0.9;
        c =l2.*M+(1-M).*l1;%        
       C = C-c.*nC;
       
       
    end
    R =Rmax./(alpha + ((beta./C.^1.1).^(Gamma)))+b;
    
    
    
    ResponsePyramid{i} = R;
end
