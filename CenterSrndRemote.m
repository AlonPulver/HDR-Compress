function [GCenter,GSrnd,GRemote] = CenterSrndRemote(Image,CenterSize,SrndSize,RemoteSize,CenterSigma,SrndSigma,RemoteSigma)

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

GaussFilterSrnd = GaussFilterSrnd.*CenterSrndMask;%*CenterSrndMissingWeight;
GaussFilterRemote = GaussFilterRemote.*SrndRemoteMask;%*SrndRemoteMissingWeight;

GCenter = imfilter(Image,GaussFilterCenter,'replicate');
GSrnd =  imfilter(Image,GaussFilterSrnd,'replicate');
GRemote =  imfilter(Image,GaussFilterRemote,'replicate');