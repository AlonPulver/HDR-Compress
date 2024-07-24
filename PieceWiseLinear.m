function [W] = PieceWiseLinear(input, Imax, Imean)
% if input <0.3
%     W = 0;
%     return
% end
%0.5<V<0.61 good value is about 0.57
V = 0.57 + 0.66*(Imean - 0.57);
V =950/double(Imax);
C1 = 1.2;
C2 = 1.7;
if (input > V) 
    W = 4*C1*(input - V)*(1 - input)/((1 - V)^2);
else
    W = -4*C2*(V-input)*input/(3*V^2);
end
end