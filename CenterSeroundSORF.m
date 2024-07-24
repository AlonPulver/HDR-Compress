function Iout = CenterSeroundSORF(Image,CenterSize,SrndSize,RemoteSize,CenterSigma,SrndSigma,RemoteSigma)
ShowPlots = false;

if(mod((SrndSize - CenterSize),2)~=0)
    SrndSize = SrndSize + 1;
end
if(mod((RemoteSize - SrndSize),2)~=0)
    RemoteSize = RemoteSize + 1;
end

GaussFilterCenter = fspecial('gaussian', CenterSize, CenterSigma);
GaussFilterSrnd = fspecial('gaussian', SrndSize, SrndSigma);
GaussFilterRemote = fspecial('gaussian', RemoteSize, RemoteSigma);

CenterSrndMask = ones(size(GaussFilterSrnd));
CenterSrndMask((SrndSize-CenterSize)/2+1:(SrndSize-CenterSize)/2+CenterSize,(SrndSize-CenterSize)/2+1:(SrndSize-CenterSize)/2+CenterSize)=0;

SrndRemoteMask = ones(size(GaussFilterRemote));
SrndRemoteMask((RemoteSize-SrndSize)/2+1:(RemoteSize-SrndSize)/2+SrndSize,(RemoteSize-SrndSize)/2+1:(RemoteSize-SrndSize)/2+SrndSize)=0;

GaussFilterSrnd = GaussFilterSrnd.*CenterSrndMask;
GaussFilterRemote = GaussFilterRemote.*SrndRemoteMask;

GCenter = imfilter(Image,GaussFilterCenter,'replicate');
GSrnd =  imfilter(Image,GaussFilterSrnd,'replicate');
GRemote =  imfilter(Image,GaussFilterRemote,'replicate');

%normalize all from now on
GCenter = GCenter./max(GCenter(:));
GSrnd = GSrnd./max(GSrnd(:));
GRemote = GRemote./max(GRemote(:));

kCenter = 0.7;
kSrnd = 0.7;

sorfCenter = Sorf4Xray(Image,1,4); 
%RMCenter = kCenter*mean(max(sorfCenter)) - sorfCenter;
RMCenter = kCenter*max(max(sorfCenter)) - 2*sorfCenter;
RMCenter(RMCenter<0) = 1e-9;
RMCenter = RMCenter./max(RMCenter(:)); 

sorfSrnd = Sorf4Xray(Image,4,6);
%RMSrnd = kSrnd*mean(max(sorfSrnd)) - sorfSrnd;
RMSrnd = kSrnd*max(max(sorfSrnd)) - 2*sorfSrnd;
RMSrnd(RMSrnd<0) = 1e-9;
RMSrnd = RMSrnd./max(RMSrnd(:));

alphaCenter = 1;
alphaSrnd = 1;

betaCenter= 1;
betaSrnd = 1;

cCenterRemote = 3;
cSrndRemote = 3;

CenterAdaptation = GCenter./(alphaCenter*GCenter+betaCenter + cCenterRemote*RMCenter.*GRemote);
SrndAdaptation = GSrnd./( alphaSrnd*GSrnd+betaSrnd+ cSrndRemote*RMSrnd.*GRemote);

dCenter = 1;
dSrnd = 0.2;

Iout = dCenter*CenterAdaptation - dSrnd*SrndAdaptation ;


