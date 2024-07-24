function [BlurredPyramid]= GenerateBlurredBilateralPyramid(I,N,gap)

addpath('..\FastBiLateral'); 

BlurredPyramid = cell(1,N+gap);
BlurredPyramid{1} = I;

SigmaSfactor = 3;
sigmaS0 = SigmaSfactor^(0.5);
sigmaR0 = max(I(:))/10;
BlurredPyramid{2} = bfilter2(I,ceil(2*sigmaS0),[sigmaS0,sigmaR0]);

sigmaSjminus1 = SigmaSfactor^(0.5)*sigmaS0;
sigmaRjminus1 = sigmaR0/2;
BlurredPyramid{3} = bfilter2(BlurredPyramid{2}./max(max(BlurredPyramid{2})),ceil(2*sigmaSjminus1),[sigmaSjminus1,sigmaRjminus1]);

for j = 4:N+1
    sigmaSj = 2*sigmaSjminus1;
    sigmaRjFactor = sigmaR0/2^j;
    BlurredPyramid{j} = bfilter2(BlurredPyramid{j-1}./max(max(BlurredPyramid{j-1})),ceil(2*sigmaSj),[sigmaSj,sigmaRjFactor]);
    sigmaSjminus1 = sigmaSj;
end