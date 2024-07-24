function SorfNorm = CalculateSorf(GCenter,GSrnd,GRemote)

cCenter = 0.7;

Sorf = abs(GCenter-cCenter*GSrnd);

SorfNorm = NormAndConvertImagetoDouble(Sorf);