function Iout = CenterSeroundAdaptation(Image,CenterSize,SrndSize,RemoteSize,CenterSigma,SrndSigma,RemoteSigma)
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

CenterSrndMissingWeight = sum(sum((GaussFilterSrnd.*~CenterSrndMask)));
SrndRemoteMissingWeight = sum(sum((GaussFilterRemote.*~SrndRemoteMask)));

%GaussFilterSrnd = GaussFilterSrnd.*CenterSrndMask*CenterSrndMissingWeight;
GaussFilterRemote = GaussFilterRemote.*SrndRemoteMask;%*SrndRemoteMissingWeight;

GCenter = imfilter(Image,GaussFilterCenter,'replicate');
GSrnd =  imfilter(Image,GaussFilterSrnd,'replicate');
GRemote =  imfilter(Image,GaussFilterRemote,'replicate');

%normalize all from now on
GCenter = GCenter./max(GCenter(:));
GSrnd = GSrnd./max(GSrnd(:));
GRemote = GRemote./max(GRemote(:));

% if(ShowPlots)
%     figure; imshow(GCenter,[]); title('GCenter');
%     figure; imshow(GSrnd,[]); title('GSrnd');
%     figure; imshow(GRemote,[]); title('GRemote');
% end


alphaCenter = 0.7;
alphaSrnd = 0.7;

betaCenter= 0.1;
betaSrnd = 0.1;

dCenter = 1;
dSrnd = 0;%-1.2;

cCenter = 1;%0.005;
kCenter = 1;
mCenter =0; %2,1-5

cSrnd = 1;%0.005;
kSrnd = 1;
mSrnd = 0; %2,1-5

aCenter = abs(GCenter-mCenter*GSrnd);
%RMCenter = cCenter.*(kCenter*Imax - aCenter)
RMCenter = cCenter.*(kCenter*max(max(aCenter)) - aCenter);
%RMCenter = cCenter.*(kCenter*mean(max(Image)) - aCenter);
RMCenter(RMCenter<0) = 1e-9;
%RMCenterNorm = RMCenter./max(RMCenter(:));
CenterRemoteAdaptationFactor = (RMCenter.*GRemote)./max(max((RMCenter.*GRemote))); 

aSrnd = abs(GSrnd-mSrnd*GCenter);
%RMSrnd = cSrnd.*(kSrnd*Imax - aSrnd);
RMSrnd = cSrnd.*(kSrnd*max(max(aSrnd)) - aSrnd);
%RMSrnd = cSrnd.*(kSrnd*mean(max(Image)) - aSrnd);
RMSrnd(RMSrnd<0) = 1e-9;
%RMSrndNorm = RMSrnd./max(RMSrnd(:));
SrndRemoteAdaptationFactor = RMSrnd.*GRemote./max(max((RMSrnd.*GRemote))); 

if(ShowPlots)
    figure; imshow(RMCenter,[]); title('RMCenter');
    figure; imshow(RMSrnd,[]); title('RMSrnd');
    figure; imhist(GRemote(:)./max(GRemote(:))); title('GRemote');
    figure; imhist(RMCenter(:)./max(RMCenter(:))); title('RMCenter');
    figure; imhist(CenterRemoteAdaptationFactor(:)./max(CenterRemoteAdaptationFactor(:))); title('CenterRemoteAdaptationFactor');
end

CenterLocalAdaptationFactor = alphaCenter*GCenter+betaCenter;
SrndLocalAdaptationFactor = alphaSrnd*GSrnd+betaSrnd;

if(ShowPlots)
    figure; imshow(CenterRemoteAdaptationFactor,[]); title('CenterRemoteAdaptationFactor');
    figure; imshow(CenterLocalAdaptationFactor,[]); title('CenterLocalAdaptationFactor');
    figure; imshow(SrndRemoteAdaptationFactor,[]); title('SrndRemoteAdaptationFactor');
    figure; imshow(SrndLocalAdaptationFactor,[]); title('SrndLocalAdaptationFactor');
end

cCenterRemote = 2;
cSrndRemote = 2;

CenterAdaptationFactor = CenterLocalAdaptationFactor + cCenterRemote*CenterRemoteAdaptationFactor;
SrndAdaptationFactor = SrndLocalAdaptationFactor + cSrndRemote*SrndRemoteAdaptationFactor;

CenterAdaptation = GCenter./(CenterAdaptationFactor);
SrndAdaptation = GSrnd./(SrndAdaptationFactor);


if(ShowPlots)
    figure; imshow(CenterAdaptationFactor,[]); title('CenterAdaptationFactor');
    figure; imshow(SrndAdaptationFactor,[]); title('SrndAdaptationFactor');
    figure; imshow(CenterAdaptation,[]); title('CenterAdaptation');
    figure; imshow(SrndAdaptation,[]); title('SrndAdaptation');
end

ICenterMinusSrnd = dCenter*CenterAdaptation - dSrnd*SrndAdaptation ;
IPossitive = ICenterMinusSrnd - min(min(ICenterMinusSrnd)); % if negative it will come to zero and above
Iout= IPossitive./max(max(IPossitive));

if(ShowPlots)
    figure; imshow(IoutNorm,[]); title('Iout');
end
