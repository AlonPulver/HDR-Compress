
GammaParams{1}.a = 0.7;
GammaParams{2}.a = 0.7;
GammaParams{3}.a = 0.7;
GammaParams{4}.a = 0.7;
GammaParams{5}.a = 0.7;
GammaParams{6}.a = 0.7;

GammaParams{1}.b = 1;
GammaParams{2}.b = 1;
GammaParams{3}.b = 1;
GammaParams{4}.b = 1;
GammaParams{5}.b = 1;
GammaParams{6}.b = 1;

% GammaParams{1}.c = 0.5;
% GammaParams{2}.c = 2;
% GammaParams{3}.c = 1.5;
% GammaParams{4}.c = 1.5;
% GammaParams{5}.c = 1.5;
% GammaParams{6}.c = 1.5;

% GammaParams{1}.c = 20;
% GammaParams{2}.c = 30;
% GammaParams{3}.c = 40;
% GammaParams{4}.c = 50;
% GammaParams{5}.c = 60;
% GammaParams{6}.c = 70;

GammaParams{1}.c = 2;
GammaParams{2}.c = 4;
GammaParams{3}.c = 8;
GammaParams{4}.c = 16;
GammaParams{5}.c = 32;
GammaParams{6}.c = 64;

% GammaParams{1}.c = 5;
% GammaParams{2}.c = 5;
% GammaParams{3}.c = 5;
% GammaParams{4}.c = 5;
% GammaParams{5}.c = 5;
% GammaParams{6}.c = 5;

% Levels = zeros(4,6);
% Levels(1,:) = [1 2 4 2 3 5];
% Levels(2,:) = [2 4 6 3 6 9];
% Levels(3,:) = [3 6 8 4 8 12];
% Levels(4,:) = [5 10 15 6 12 18];
% Levels(5,:) = [7 21 36 10 15 25];
% Levels(6,:) = [20 40 60 12 20 30];

Levels = zeros(4,6);
Levels(1,:) = [1 2 4 0.2 0.3 0.5];
Levels(2,:) = [2 4 6 0.3 0.6 0.9];
Levels(3,:) = [3 6 8 0.4 0.8 1.2];
Levels(4,:) = [5 10 15 0.6 1.2 1.8];
Levels(5,:) = [7 21 36 1.0 1.5 2.5];
Levels(6,:) = [20 40 60 1.2 2.0 3.0];

SorfParams{1}.start = 1;
SorfParams{1}.end = 6;
SorfParams{2}.start = 2;
SorfParams{2}.end = 5;
SorfParams{3}.start = 3;
SorfParams{3}.end = 6;
SorfParams{4}.start = 4;
SorfParams{4}.end = 6;
SorfParams{5}.start = 5;
SorfParams{5}.end = 6;
SorfParams{6}.start = 6;
SorfParams{6}.end = 6;
