
function GammaPyrmaid = CalculteGamma(SorfPyramid,GammaParams,ContrastPyramid,ModulationPyramid)

N = length(SorfPyramid);
GammaPyrmaid = cell(1,N);

for i = 1:N
    max(SorfPyramid{i}(:))
    %SorfPyramid{i} =(1-ModulationPyramid{i}).* medfilt2(SorfPyramid{i},[3 3])+0.5;
    
    SorfPyramid{i} = medfilt2(SorfPyramid{i},[3 3]);    
   
    S = (SorfPyramid{i});
    max(SorfPyramid{i}(:))
    C=ContrastPyramid{i};
   
    maxC = max(C(:));
    minC = min(C(:));
     c =  (maxC - minC);
   
 if(i+2 <= N+1) 
    I = my_impyramid(my_impyramid(ModulationPyramid{i+2}, 'expand'),'expand');
    else
       I = my_impyramid(ModulationPyramid{i+1}, 'expand');  
    end

%     if i == 5;
%         GammaParams{i}.c = 3;%(20-5);       
%     elseif i == 4         
%         GammaParams{i}.c = 3;%(20-5);
%     elseif i == 3       
%         GammaParams{i}.c = 15;%(20-5);%35-10;
%      elseif i == 2        
%          GammaParams{i}.c = 25;%(20-5);
%       
%     elseif i == 1        
%         GammaParams{i}.c =35;% (30-5);
%       
%     else
%         GammaParams{i}.c = 3;
%     end
    
    
     if i == 5;
        GammaParams{i}.c = 5;%(20-5);
        l1 = 15;
        l2 = 5;
         GammaParams{i}.c = 0.05.*(l2.*I+(1-I).*l1);
    elseif i == 4         
        GammaParams{i}.c = 15;%(20-5);
        l1 = 15;
        l2 = 5;
        % GammaParams{i}.c =l2.*I+(1-I).*l1;
    elseif i == 3       
        GammaParams{i}.c = 15;%(20-5);%35-10;
         l1 = 15;
        l2 = 5;
        %GammaParams{i}.c =l2.*I+(1-I).*l1;
     elseif i == 2        
         GammaParams{i}.c = 35;%(20-5);
         l1 = 25;
         l2 = 15;
         GammaParams{i}.c =l2.*I+(1-I).*l1;
    elseif i == 1        
        GammaParams{i}.c =55;% (30-5);
        l1 = 35;
        l2 = 15;
        GammaParams{i}.c =l2.*I+(1-I).*l1;% (30-5);
      
    else
       GammaParams{i}.c = 1;
        l1 = 45;
        l2 = 15;
        GammaParams{i}.c =l2.*I+(1-I).*l1;
    end

    %SMod = (GammaParams{i}.a* max(mean(S)) - GammaParams{i}.b*S);
    %SMod =(GammaParams{i}.a* mean(max(S)) - GammaParams{i}.b*S);
    % SMod = (1.5* mean(max(S)) - 1*S);
    SMod = (max(S(:)) - 1*S);
     
    SNorm = (SMod) + 1e-9;
    SAbs = abs(SMod);
    %SAbs = SAbs./max(SAbs(:));
    %GammaPyrmaid{i} = GammaParams{i}.c;
    %GammaPyrmaid{i} = GammaParams{i}.c./SNorm;
    %GammaPyrmaid{i} = GammaParams{i}.c.*SNorm;
    %GammaPyrmaid{i} = GammaParams{i}.c*SNorm + GammaParams{i}.c;
   
    GammaPyrmaid{i} =GammaParams{i}.c.*SNorm;
%     figure;
%     subplot(2,2,1)
%     imshow(S,[]);
%     title('S');
%     subplot(2,2,2)
%     imshow(SMod,[]);
%     title('SMod');
%     subplot(2,2,3)
%     imshow(SAbs,[]);
%     title('SAbs');
%     subplot(2,2,4)
%     imshow(SNorm,[]);
%     title('SNorm');
% 
%     figure;
%     subplot(2,2,1)
%     hist(S(:));
%     title('S');
%     subplot(2,2,2)
%     hist(SMod(:));
%     title('SMod');
%     subplot(2,2,3)
%     hist(SAbs(:));
%     title('SAbs');
%     subplot(2,2,4)
%     hist(SNorm(:));
%     title('SNorm');
end 