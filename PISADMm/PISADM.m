% =========================================================================

% PISADM MATLAB Code
%
% Copyright (c) 2026, Limin Zou Lab, Harbin Institute of Technology
% All rights reserved.
%
% This code was developed for research and academic use only.
% Unauthorized copying, modification, distribution, or commercial use of
% this code, in whole or in part, is prohibited without prior written
% permission from the author(s).
%
% Author: Caini Xiao
% Affiliation:
% Institute of Ultra-precision Optoelectronic Instrument Engineering,
% Harbin Institute of Technology, Harbin 150001, China
%
% If you use this code in academic work, please cite the associated paper.
% This code is provided "as is" without warranty of any kind.
% =========================================================================
%
% This code was developed for research purposes only.
% Unauthorized copying, modification, distribution, or commercial use of
% this code, in whole or in part, is prohibited without prior permission
% from the author(s).
%
% Author: Caini Xiao

% Affiliation: Institute of Ultra-precision Optoelectronic Instrument Engineering, Harbin Institute of Technology, Harbin 150001, China
%
% If you use this code in academic work, please cite the corresponding
% paper or acknowledge the author(s) appropriately.
% =========================================================================

clear;
addpath(genpath('SACDm-main\SACDm'));

NA = 1.24;
Lambda = 0.525;
PixelSize = 0.0625;
ImSize = 256;
IllPitch = 7;
Extent = floor(0.6*ImSize/IllPitch);
ScanParameter = [1,6,6];
PreFrameL = 0;
PreFrameD = 0;
PinholeR = ceil(0.61*Lambda/NA/PixelSize);
WindowSize = IllPitch+4;
[X,Y] = meshgrid(-ceil((WindowSize-1)/2):ceil((WindowSize-1)/2));

deta = PinholeR/2;
W = fspecial('gaussian',[WindowSize,WindowSize],deta);
W = W/max(W(:));
W = W.*W';

DataPath = 'DemoData.tif';

ShiftVectors = [1.7754 -1.2418; -1.5942 -1.8840]/2;
LatticeVectors = [14.5037 -2.8994; -9.7493 -11.0847; -4.7544 13.9842]/2;
OffsetVector = [253.3592 254.3592]/2;

PositionN = 36;
Frame = 10;
subFrame = 10;
TimePoints = 1;
Numz = 1;
Flag = 1;
Interval = PositionN*Numz;
SACDstack = [];

for t = 1:TimePoints
    offsetf = Interval*(t-1)*2;
    for z = 1:Numz
        for p = 1:PositionN
            RawIms = [];
            for f = 1:Frame
                RawIms(:,:,f) = double(imread(DataPath,p+(f-1)*PositionN));
            end

            imgstack = single(RawIms(:,:,1:subFrame));
            ifsparsedecon = false;
            iter1 = 7;
            iter2 = 4;

            [SRimg,DenImsdecon] = SACDm(imgstack,'pixel',62,'NA',NA,'wavelength',525,'ifsparsedecon',ifsparsedecon,'ACorder',2,'ifbackground',true,'iter1',iter1,'iter2',iter2);
            LRimg = mean(double(imgstack),3);
            LRimg = LRimg./max(LRimg(:));
            background = 0.02;
            order = 2;
            SRimg2vis = SRimg.^0.5;
            SRimg2vis(SRimg2vis < order*background*max(SRimg2vis(:))) = 0;
            SACDstack(:,:,p,z,t) = SRimg2vis;
        end
    end
end

PixelSize = PixelSize/2;
ImSize = ImSize*2;
IllPitch = IllPitch*2;
Extent = floor(0.6*ImSize/IllPitch);
PinholeR = ceil(0.61*Lambda/NA/PixelSize);
[X,Y] = meshgrid(-ceil((WindowSize-1)/2):ceil((WindowSize-1)/2));

deta = PinholeR/2;
W = fspecial('gaussian',[WindowSize,WindowSize],deta);
W = W/max(W(:));
W = W.*W';

ShiftVectors = ShiftVectors*2;
LatticeVectors = LatticeVectors*2;
OffsetVector = OffsetVector*2;

Order = [PreFrameD+1:prod(ScanParameter(2:3)),1:PreFrameD];
Order = Order(1:prod(ScanParameter(2:3)));

Numz = 1;
ISMStack = [];
for z = 1:Numz
    MismImage = zeros(ImSize,ImSize);
    ConfocalImage = zeros(ImSize/2,ImSize/2);
    for frame = 1:prod(ScanParameter(2:3))
        WideFieldImage = zeros(ImSize,ImSize);
        Image = SACDstack(:,:,frame);
        LatticePoints = generate_lattice(size(Image),LatticeVectors,OffsetVector);
        [ScanFast,ScanSlow] = ind2sub(ScanParameter(2:3),frame);
        ShiftVector = ShiftVectors(1,:)*(ScanFast-1)+ShiftVectors(2,:)*(ScanSlow-1);
        LatticePoints(:,1:2) = LatticePoints(:,1:2)+repmat(ShiftVector,[size(LatticePoints,1),1]);
        LatticePoints = LatticePoints(ceil(WindowSize/2)<LatticePoints(:,1),:);
        LatticePoints = LatticePoints(ceil(WindowSize/2)<LatticePoints(:,2),:);
        LatticePoints = LatticePoints(size(Image,1)-ceil(WindowSize/2)>LatticePoints(:,1),:);
        LatticePoints = LatticePoints(size(Image,2)-ceil(WindowSize/2)>LatticePoints(:,2),:);

        WindowCen = round(LatticePoints(:,1:2));
        Shift = WindowCen-LatticePoints(:,1:2);
        Col = repmat(X,[1,1,size(WindowCen,1)]);
        Row = repmat(Y,[1,1,size(WindowCen,1)]);
        WindowRow = permute(repmat(WindowCen(:,1),[1,WindowSize,WindowSize]),[2,3,1])+Row;
        WindowCol = permute(repmat(WindowCen(:,2),[1,WindowSize,WindowSize]),[2,3,1])+Col;
        WindowInd = sub2ind([ImSize,ImSize],WindowRow(:),WindowCol(:));

        WideFieldImage(WindowInd) = WideFieldImage(WindowInd)+Image(WindowInd);
        SubImages = reshape(Image(WindowInd),WindowSize,WindowSize,[]);
        SubImages = subpixel_shift(SubImages,Shift);
        SubImages = SubImages.*repmat(W,[1,1,size(WindowCen,1)]);
        SubImages = subpixel_shift(SubImages,-2*Shift);
        SubImages = SubImages(2:end-1,2:end-1,:);

        Col = repmat(X(2:end-1,2:end-1),[1,1,size(WindowCen,1)]);
        Row = repmat(Y(2:end-1,2:end-1),[1,1,size(WindowCen,1)]);
        WindowRow = permute(repmat(WindowCen(:,1),[1,WindowSize-2,WindowSize-2]),[2,3,1])+Row;
        WindowCol = permute(repmat(WindowCen(:,2),[1,WindowSize-2,WindowSize-2]),[2,3,1])+Col;
        WindowInd = sub2ind([ImSize,ImSize],WindowRow(:),WindowCol(:));
        MismImage(WindowInd) = MismImage(WindowInd)+SubImages(:);

        SumSubIm = squeeze(sum(sum(SubImages,1),2));
        WindowColC = squeeze(WindowCol(ceil(size(Col,1)/2),ceil(size(Col,2)/2),:));
        WindowRowC = squeeze(WindowRow(ceil(size(Col,1)/2),ceil(size(Col,2)/2),:));
        WindowIndC = sub2ind([ImSize/2,ImSize/2],round(WindowRowC(:)/2),round(WindowColC(:)/2));
        ConfocalImage(WindowIndC) = SumSubIm;
    end

    ISMStack(:,:,z) = MismImage;
    figure(2);
    imshow(ISMStack(WindowSize+1:end-WindowSize,WindowSize+1:end-WindowSize,z),[]);
    colormap(gca,hot);
    title('ISM');
end

DataSavePath = DataPath(1:find(DataPath=='.',1,'last')-1);
if exist(DataSavePath,'dir') == 0
    mkdir(DataSavePath);
end

Parameters.Lambda = Lambda;
Parameters.NA = NA;
Parameters.PixelSize = PixelSize;
Parameters.IllPitch = IllPitch;
Parameters.WindowSize = WindowSize;
Parameters.Extent = Extent;
Parameters.deta = deta;
Parameters.PreFrameL = PreFrameL;
Parameters.PreFrameD = PreFrameD;
Parameters.ScanParameter = ScanParameter;
Parameters.Flag = Flag;
Parameters.PositionN = PositionN;
Parameters.Frame = Frame;
Parameters.subFrame = subFrame;
Parameters.TimePoints = TimePoints;
Parameters.Numz = Numz;
Parameters.ShiftVectors = ShiftVectors;
Parameters.LatticeVectors = LatticeVectors;
Parameters.OffsetVector = OffsetVector;

DataName = DataPath(find(DataPath=='\',1,'last')+1:find(DataPath=='.',1,'last')-1);
save([DataSavePath,'\',DataName,'PISADM.mat'],'ISMStack','Parameters');
for z = 1:Numz
    imwrite(uint16(ISMStack(:,:,z)),[DataSavePath,'\',DataName,'PISADM.tif'],'WriteMode','append');
end

function LatticePoints = generate_lattice(ImageShape,LatticeVectors,CenterPix)
    if isempty(CenterPix)
        CenterPix = ceil((ImageShape+1)/2);
        lattice_shift = [0,0];
    else
        CenterPix = CenterPix-ceil((ImageShape+1)/2);
        lattice_components = linsolve(LatticeVectors(1:2,:).',CenterPix.');
        lattice_components_centered = mod(lattice_components,1);
        lattice_shift = lattice_components-lattice_components_centered;
        CenterPix = LatticeVectors(1,:)*lattice_components_centered(1)+LatticeVectors(2,:)*lattice_components_centered(2)+ceil((ImageShape+1)/2);
    end

    NumVectors = ceil(sqrt(2)*max(ImageShape)/sqrt(sum(LatticeVectors(1,:).^2)));
    [Nc,Nr] = meshgrid(-NumVectors:NumVectors);
    LatticePoints = [[Nr(:),Nc(:)]*LatticeVectors(1:2,:),Nr(:),Nc(:)];
    LatticePoints(:,3) = LatticePoints(:,3)-lattice_shift(1);
    LatticePoints(:,4) = LatticePoints(:,4)-lattice_shift(2);
    LatticePoints(:,1:2) = [LatticePoints(:,1)+CenterPix(1),LatticePoints(:,2)+CenterPix(2)];
end

function ShiftedImages = subpixel_shift(Images,Shift)
    if ndims(Images) == 2
        Images = reshape(Images,size(Images,1),size(Images,2),1);
    end

    ImageN = size(Images,3);
    if size(Shift,1) == 1 && ImageN > 1
        Shift = repmat(Shift,[ImageN,1]);
    end

    [ColGrid,RowGrid] = meshgrid(1:size(Images,2),1:size(Images,1));
    ShiftedImages = zeros(size(Images),'like',Images);
    for idx = 1:ImageN
        RowQuery = RowGrid-Shift(idx,1);
        ColQuery = ColGrid-Shift(idx,2);
        ShiftedImages(:,:,idx) = interp2(ColGrid,RowGrid,double(Images(:,:,idx)),ColQuery,RowQuery,'linear',0);
    end

    if ImageN == 1
        ShiftedImages = ShiftedImages(:,:,1);
    end
end
