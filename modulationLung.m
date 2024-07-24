function Ilung = modulationLung(I)

lungl=1024-600-1600/2;
lungh=1024-600+1600/2;
Ilung=I;
Ilung(I<=lungl)=lungl;
Ilung(I>=lungh)=lungh;
Ilung=im2double(255.*(Ilung-min(Ilung(:)))./(max(Ilung(:))-min(Ilung(:))));

end

