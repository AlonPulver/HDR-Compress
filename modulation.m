function [M,Ilung,Ibone] = modulation(I)

bonel=1024+600-1600/2;
boneh=1024+600+1600/2;

% bonel=-300;
% boneh=1548;




lungl=1024-600-1600/2;
lungh=1024-600+1600/2;
softl=1024+32-320/2;
softh=1024+32+320/2;
liverl=1024+100-200/2;
liverh=1024+100+200/2;

Ilung=I;
Ilung(I<=lungl)=lungl;
Ilung(I>=lungh)=lungh;
Ilung=255*(Ilung-min(Ilung(:)))./(max(Ilung(:))-min(Ilung(:)));

Ibone=I;
Ibone(I<=bonel)=bonel;
Ibone(I>=boneh)=boneh;
Ibone=255*(Ibone-min(Ibone(:)))./(max(Ibone(:))-min(Ibone(:)));

Isoft=I;
Isoft(I<=softl)=softl;
Isoft(I>=softh)=softh;
Isoft=255*(Isoft-min(Isoft(:)))./(max(Isoft(:))-min(Isoft(:)));

Iliver=I;
Iliver(I<=liverl)=liverl;
Iliver(I>=liverh)=liverh;
Iliver=255*(Iliver-min(Iliver(:)))./(max(Iliver(:))-min(Iliver(:)));

% I1=(Ilung.*Ibone.*Isoft.*Iliver).^(1/4);
I =(im2double(I));
I = I./max(I(:));
I1=((Ilung)+(Ibone)+(Isoft)+(Iliver));
I1 = im2double(I1);
I1 = I1./max(I1(:));
I2 =2*I./4+ I1.*(1/2);%(I + (Iliver +Isoft)./2)./2;
d=-im2double(I2);
d=d-min(d(:));
d=d./max(d(:));
M=d;
