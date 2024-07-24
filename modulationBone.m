function Ibone = modulationBone(I)

bonel=1024+800-1600/2;
boneh=1024+800+1600/2;

Ibone=I;
Ibone(I<=bonel)=bonel;
Ibone(I>=boneh)=boneh;
Ibone=im2double(255.*(Ibone-min(Ibone(:)))./(max(Ibone(:))-min(Ibone(:))));




end
