function Contrast = Sorf4Xray(Image,StartLevel,EndLevel)

% Each level comprised of center size sorrund size center sigma and surrond
% sigma

% Levels = zeros(6,4);
% Levels(1,:) = [1 3 1 2];
% Levels(2,:) = [3 9 3 6];
% Levels(3,:) = [5 15 5 10];
% Levels(4,:) = [7 21 7 14];
% Levels(5,:) = [9 27 9 18];
% Levels(6,:) = [11 33 11 22];

Levels = zeros(6,4);
Levels(1,:) = [1 5 1 8];
Levels(2,:) = [3 9 3 12];
Levels(3,:) = [7 21 5 17];
Levels(4,:) = [12 36 7 30];
Levels(5,:) = [20 60 9 40];
Levels(6,:) = [30 90 11 50];


Contrast = zeros(size(Image));
for i=StartLevel:EndLevel
    %Contrast = Contrast + (CenterMinusSrnd(Image,Levels(i,1),Levels(i,2),Levels(i,3),Levels(i,4)));
    Contrast = Contrast + abs(CenterMinusSrnd(Image,Levels(i,1),Levels(i,2),Levels(i,3),Levels(i,4)));
end
     