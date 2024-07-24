function SorfNorm = CalculateCentrSrndRemotSorf(GCenter,GSrnd,GRemote)

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

Sorf = SrndRemoteAdaptationFactor - CenterRemoteAdaptationFactor;

SorfNorm = NormAndConvertImagetoDouble(Sorf);