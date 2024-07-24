c = linspace(0,10);
Rmax = 0.7;
c50 = 1;
b=0;
figure
for n = [0.5,1,2,10,100,500,1000]
r = (Rmax*c.^n)./(c.^n+c50.^n)+b;
plot(c,r);
hold on
end
hold off