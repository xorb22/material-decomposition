tBone = 2; % [cm]
tWater = 10;
nPoints = 20;
tBoneArr = linspace(0,tBone,nPoints);
tWaterArr = linspace(0,tWater,nPoints);
N = 20;
Io = [generateSpectrum(1e6)];

bin = [21  36;
    37 54;
    55 64;
    65 77;
    78 120];

load('muData.mat');
materialN = [8 4];
M = zeros(size(Io,1),2);
M(21:end,:) = muORho(21:end, materialN) ...
    .* repmat(muDensity(materialN)', [100 1]);

%%
disp('4x4 Pixel');
ERFfname ='ERFAll250micron.mat';
pixelSeg = '1x1';
%%
% disp('2x2 Pixel');
% ERFfname ='ERFAll250micron.mat';
% pixelSeg = '2x2';
nRlz = 100;    % how many realizations to generate
tWaterN = zeros(nRlz, size(tWaterArr,2));
tBoneN = zeros(nRlz, size(tWaterArr,2));
%%
XY = zeros(N*nPoints^2,7);
iR = 1;
for i = 1:size(tWaterArr,2)
    for j = 1:size(tBoneArr,2)
        tWater = tWaterArr(j);
        tBone = tBoneArr(j);
        % simulate what is happening for real
        [meanAtT covAtT]  = ...
            getCovMean(tWater, tBone,0, Io, ERFfname, bin,pixelSeg,0);
        for iN = 1:N
            XY(iR,1:2) = [tWater, tBone];
            XY(iR,3:end) = poissrnd(meanAtT');
            iR = iR + 1;
        end
    end
    disp(strcat('Doing this out of 11:', num2str(i)));
end
