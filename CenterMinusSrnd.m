function CenterSrndNorm = CenterMinusSrnd(Image,CenterSize,SrndSize,CenterSigma,SrndSigma)


GaussFilterCenter = fspecial('gaussian', CenterSize, CenterSigma);
mask = zeros(size(SrndSize));
mask(ceil((SrndSize-CenterSize)/2):end-ceil((SrndSize-CenterSize)/2))=1;
%mask = padarray( ones(size(GaussFilterCenter)),[ceil((SrndSize-CenterSize)/2),ceil((SrndSize-CenterSize)/2)]);
%GaussFilterSrnd = fspecial('gaussian', SrndSize, SrndSigma).*~mask;
GaussFilterSrnd = fspecial('gaussian', SrndSize, SrndSigma);


ImageFilteredCenter = imfilter(Image,GaussFilterCenter,'replicate');
ImageFilteredSrnd =  imfilter(Image,GaussFilterSrnd,'replicate');

% ImageFilteredCenter = ImageFilteredCenter./max(ImageFilteredCenter(:));
% ImageFilteredSrnd = ImageFilteredSrnd./max(ImageFilteredSrnd(:)) ;

c= 1;

CenterSrnd = ImageFilteredCenter - c*ImageFilteredSrnd;
CenterSrndNorm = NormAndConvertImagetoDouble(CenterSrnd);
