function [ Ip ] = SoftTissues( I )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

I=double(I);
I(1,1)=0;
I(1,2)=0;
Imax=max(I(:));
I(I==-2000)=0;


Igr=zeros(size(I,1),size(I,2));
Ig_srnd=Igr;

%wight for srnd
srnd_mask_size=3;
c1=floor(srnd_mask_size/2);
[x,y]=meshgrid(-c1:1:c1,-c1:1:c1);
wight_srnd=exp(-1*(x.^2+y.^2)./(200*9*0.5))./sqrt(0.05*6.2832);
wight_srnd=wight_srnd./sum(wight_srnd(:));
Ig_srnd=imfilter(I,wight_srnd);

%wight for remote
remote_mask_size=5;
c2=floor(remote_mask_size/2);
[x,y]=meshgrid(-c2:1:c2,-c2:1:c2);
wight_remote=(1./sqrt(0.1*6.2832*18))*exp(-1*(x.^2+y.^2)/(2*0.9*0.1*18));
wight_remote(c2-c1+1:1:c2+c1+1,c2-c1+1:1:c2+c1+1)=0;
wight_remote=wight_remote./sum(wight_remote(:));


val=1280;

diff_cntr=(I-val);
%diff_srnd=(Ig_srnd-val_s);

diff_cntr_on=(diff_cntr).*(diff_cntr>=0);
diff_cntr_off=diff_cntr.*(diff_cntr<0);

Ion=I.*((diff_cntr)>=0);
Ioff=I.*((diff_cntr)<0);

diffmax_on=max(abs(diff_cntr_on(:)));
diffmax_off=max(abs(diff_cntr_off(:)));

sig_off =-diff_cntr_off.*(diff_cntr_off+diffmax_off);
sig_off=1*val./max(sig_off(:)).*sig_off;
sig_on =diff_cntr_on.*(diff_cntr_on-1.5*diffmax_on);
if max(abs(sig_on(:)))==0
    sig_on=1;
end;
sig_on=1*val./max(abs(sig_on(:))).*sig_on;

Ron=Ion-0.5*sig_on.*Ig_srnd/max(Ig_srnd(:));
Roff=Ioff-0.5*sig_off.*Ig_srnd/max(Ig_srnd(:));

 Ip=Ron+Roff;
 Ip=Ip-min(Ip(:));
 %Ip=Ip.*sqrt(Ig_srnd);
end

