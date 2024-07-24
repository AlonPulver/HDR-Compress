function [W] = SineStretch(input, a, b)
W = sin(input*a - b);
end