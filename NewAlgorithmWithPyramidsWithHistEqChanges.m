function[FinalImage] = NewAlgorithmWithPyramidsWithHistEqChanges(IOriginal,ShowPlots,PlotR)

I0CLAHE = adapthisteq(IOriginal,'Distribution','exponential');

N=3;

padFactor = 2^N;
[r,c] = size(IOriginal);
padR = 0;
padC = 0;
if(mod(r,padFactor)~=0)
    padR = padFactor - mod(r,padFactor);
end
if(mod(c,padFactor)~=0)
    padC = padFactor - mod(c,padFactor);
end

I0 = padarray(IOriginal,[padR padC],'post');

[BlurredPyramid, ContrastPyramid]= GenerateContrastPyramid(I0,N,2);

GammaParams = cell(1,N);

GammaParams{1}.a = 1;
GammaParams{2}.a = 2;
GammaParams{3}.a = 1;

GammaParams{1}.b = 2;
GammaParams{2}.b = 2;
GammaParams{3}.b = 2;

GammaParams{1}.c = 1;
GammaParams{2}.c = 2;
GammaParams{3}.c = 1.5;

% S0 =CalculateCenterSrndSorf(BlurredPyramid{1},1,6);
% S1 =CalculateCenterSrndSorf(BlurredPyramid{2},2,5);
% S2 =CalculateCenterSrndSorf(BlurredPyramid{3},5,6);

SorfPyramid = ContrastPyramid(1:N);
GammaPyrmaid = CalculteGamma(SorfPyramid,GammaParams);

ResponsePyramid = CalculateResponse(ContrastPyramid,GammaPyrmaid);

F0= CollapseResponsePyramid(ResponsePyramid,ContrastPyramid);
FinalImage = F0(1:end-padR,1:end-padC);

%%

% % inverse function
% 
% n1 = mean(mean(S0Norm));
% n2 = mean(mean(S1Norm));
% n3 = mean(mean(S2Norm));
% 
% % n1 = 2;
% % n2 = 2;
% % n3 = 2;
% 
% % n1 = 1;
% % n2 = 1/1.8;
% % n3 = 1/2;
% 
% % n1 = mean(mean(S0Norm));
% % n2 = mean(mean(S1Norm));
% % n3 = mean(mean(S2Norm));
% 
% M0 = S0Norm;
% M1 = S1Norm;
% M2 = S2Norm;
% 
% % M0 = S0Mod;
% % M1 = S1Mod;
% % M2 = S2Mod;
% 
% % M0 = S0Norm./max(S0Norm(:));
% % M1 = S1Norm./max(S1Norm(:));
% % M2 = S2Norm./max(S2Norm(:));
% 
% Rn1 = Rmax./(alpha + ((beta1./C1).^(n1)))+b;
% Rn2 = Rmax./(alpha + ((beta2./C2).^(n2)))+b;
% Rn3 = Rmax./(alpha + ((beta3./C3).^(n3)))+b;
% 
% R23 = Rn2.*my_impyramid(Rn3, 'expand');
% R123 = Rn1.*my_impyramid(R23, 'expand');
%  
% R123 = R123(1:end-padR,1:end-padC);
% 
% C1Inverse = beta1./((Rmax./(Rn1-b)-alpha).^(1./(n1+M0)));
% C2Inverse = beta2./((Rmax./(Rn2-b)-alpha).^(1./(n2+M1)));
% C3Inverse = beta3./((Rmax./(Rn3-b)-alpha).^(1./(n3+M2)));
% 
% % C1Inverse = beta1./((Rmax./(R1-b)-alpha).^(1./n1));
% % C2Inverse = beta2./((Rmax./(R2-b)-alpha).^(1./n2));
% % C3Inverse = beta3./((Rmax./(R3-b)-alpha).^(1./n3));
% 
% C1Inverse = real(C1Inverse);
% C2Inverse = real(C2Inverse);
% C3Inverse = real(C3Inverse);
% 
% I2Inverse = C3Inverse;%.*my_impyramid(I3, 'expand');
% %I2Inverse = I2Inverse./max(I2Inverse(:));
% I1Inverse = C2Inverse.*my_impyramid(I2Inverse, 'expand');
% %I1Inverse = I1Inverse./max(I1Inverse(:));
% I0Inverse = C1Inverse.*my_impyramid(I1Inverse, 'expand');
%  
% FinalImageInverse = I0Inverse(1:end-padR,1:end-padC);

%%

if(ShowPlots)
figure;
subplot(1,3,1)
imshow(I1,[]);
subplot(1,3,2)
imshow(I2,[]);
title('I');
subplot(1,3,3)
imshow(I3,[]);

figure;
subplot(3,3,1)
imshow(C1,[]);
subplot(3,3,2)
imshow(C2,[]);
title('C');
subplot(3,3,3)
imshow(C3,[]);

subplot(3,3,4)
imshow(R1,[]);
subplot(3,3,5)
imshow(R2,[]);
title('R');
subplot(3,3,6)
imshow(R3,[]);

subplot(3,3,7)
imshow(C1Inverse,[]);
subplot(3,3,8)
imshow(C2Inverse,[]);
title('Cinv');
subplot(3,3,9)
imshow(C3Inverse,[]);

figure;
subplot(1,3,1)
imshow(I0Inverse,[]);
subplot(1,3,2)
imshow(I1Inverse,[]);
title('I Inverse');
subplot(1,3,3)
imshow(I2Inverse,[]);

figure;
subplot(3,3,1)
hist(C1(:));
subplot(3,3,2)
hist(C2(:));
title('C');
subplot(3,3,3)
hist(C3(:));

subplot(3,3,4)
hist(R1(:));
subplot(3,3,5)
hist(R2(:));
title('R');
subplot(3,3,6)
hist(R3(:));

subplot(3,3,7)
hist(C1Inverse(:));
subplot(3,3,8)
hist(C2Inverse(:));
title('Cinv');
subplot(3,3,9)
hist(C3Inverse(:));

figure;
subplot(1,3,1)
hist(S0(:));
subplot(1,3,2)
hist(S1(:));
title('S');
subplot(1,3,3)
hist(S2(:));

figure;
subplot(1,3,1)
hist(S0Abs(:));
subplot(1,3,2)
hist(S1Abs(:));
title('S abs');
subplot(1,3,3)
hist(S2Abs(:));

figure;
subplot(1,3,1)
hist(S0Norm(:));
subplot(1,3,2)
hist(S1Norm(:));
title('S norm');
subplot(1,3,3)
hist(S2Norm(:));

figure;
subplot(4,1,1)
hist(I0(:));
title('Original image');
subplot(4,1,2)
hist(FinalImage(:));
title('Final result');
subplot(4,1,3)
hist(FinalImageInverse(:));
title('Final inverse result');
subplot(4,1,4)
hist(I0CLAHE(:));
title('CLAHE');
end

%%
if(PlotR)
Rn1Flat = Rn1(:);
Rn2Flat = Rn2(:);
Rn3Flat = Rn3(:);

C1Flat = C1(:);
C2Flat = C2(:);
C3Flat = C3(:);

R1Flat = R1(:);
R2Flat = R2(:);
R3Flat = R3(:);

[C1Unique, m1] = unique(C1Flat);
[C2Unique, m2] = unique(C2Flat);
[C3Unique, m3] = unique(C3Flat);

R1Uunique = R1Flat(m1);
R2Uunique = R2Flat(m2);
R3Uunique = R3Flat(m3);

Rn1Uunique = Rn1Flat(m1);
Rn2Uunique = Rn2Flat(m2);
Rn3Uunique = Rn3Flat(m3);

figure;
subplot(1,3,1)
plot(C1Unique,Rn1Uunique);
hold on
plot(C1Unique,R1Uunique,'r');
hold off

subplot(1,3,2)
plot(C2Unique,Rn2Uunique);
hold on
plot(C2Unique,R2Uunique,'r');
hold off


title('R vs 1 / C');
subplot(1,3,3)
plot(C3Unique,Rn3Uunique);
hold on
plot(C3Unique,R3Uunique,'r');
hold off
end

%%
if(PlotR)
C1InverseFlat = C1Inverse(:);
C2InverseFlat = C2Inverse(:);
C3InverseFlat = C3Inverse(:);

[C1InverseUnique, l1] = unique(C1InverseFlat);
[C2InverseUnique, l2] = unique(C2InverseFlat);
[C3InverseUnique, l3] = unique(C3InverseFlat);

Rn1UuniqueOfInverse = Rn1Flat(l1);
Rn2UuniqueOfInverse = Rn2Flat(l2);
Rn3UuniqueOfInverse = Rn3Flat(l3);

figure;
subplot(1,3,1)
plot(C1Unique,Rn1Uunique);
hold on
plot(C1InverseUnique,Rn1UuniqueOfInverse,'r');
hold off

subplot(1,3,2)
plot(C2Unique,Rn2Uunique);
hold on
plot(C2InverseUnique,Rn2UuniqueOfInverse,'r');
hold off


title('R vs 1 / C inverse');
subplot(1,3,3)
plot(C3Unique,Rn3Uunique);
hold on
plot(C3InverseUnique,Rn3UuniqueOfInverse,'r');
hold off
end