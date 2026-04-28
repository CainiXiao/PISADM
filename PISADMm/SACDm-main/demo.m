% clear;clc;close all;
%% Involve SACDm
addpath(genpath('./SACDm'));
addpath(('D:\FluctuationSimulation\20240626New\FluctuationSimulation\Functions'));
%% Read data
FilePath ='G:\20251206-MUSIC\COS71771KDELmoxMAPLE_001_20251206_170951\roi1_seq1_WF488_Green_ste1.mrc';
FileName = FilePath(find(FilePath=='\',1,'last')+1:find(FilePath=='.',1,'last')-1);
[Header,RawIms] = ReadMRC(FilePath);
Height = single(Header(1));
Width = single(Header(2));
Frame = single(Header(3));
RawIms = single(reshape(RawIms,Height,Width,Frame));
RawIms = rot90(RawIms,1);
% FilePath ='F:\博士课题\毕业\L-SACD\PISADM\SpotBlinkingN_1_20.tif';
% FileName = FilePath(find(FilePath=='\',1,'last')+1:find(FilePath=='.',1,'last')-1);
% for f=1:20
%     RawIms(:,:,f) = double(imread(FilePath,f));  % 读取单帧图像
% end
% % imgstack = single(DenImages(:,:,1:18));
% subFrame = 20;
% imgstack = single(RawIms(:,:,1:subFrame));

% imgstack = imreadstack('561 scmos-30ms-C1_2020-09-13_2-ROI.tif');
%% Parameters
ifsparsedecon = true;%false
iter1=0;
iter2=2;
%% SACD recon
NA = 1.49;
[SRimg,DenImsdecon] = SACDm(RawIms(100:484,100:484,1:100),'pixel',62,'NA',NA,'wavelength',525,'ifsparsedecon',ifsparsedecon,'ACorder',2,'ifbackground',true,'iter1',iter1,'iter2',iter2);
%稀疏与否是ifsparsedecon的true或false ；SOFI与SACD区别：SOFI的iter1=0,[0,15]，SACD的iter1不等于0,[7,8]；
%% Visualization
LRimg = mean(double(RawIms),3);%imfilter(mean(double(imgstack),3),generate_rsf(1));%
LRimg = LRimg./max(LRimg(:));
% figure;imshow(LRimg,'colormap',hot)
background = 0.02;order = 2;
SRimg2vis = SRimg.^0.5;
SRimg2vis(SRimg2vis < order * background * max(SRimg2vis(:))) = 0;
figure;imshow(SRimg2vis,[],'colormap',hot);set(gcf,'unit','centimeter','position',[12,6,5.5,5.5]);set(gca,'position',[0.0,0.0,1,1]);
% imwrite(SRimg2vis./max(SRimg2vis(:)),'SACDdemo.tif')
SRimg2vis=single(SRimg2vis);
%% 
Directory = [FilePath(1:find(FilePath=='.',1,'last')-1)];
if exist(Directory,'dir')==0
    mkdir(Directory);
end
if iter1==0
    FID = fopen([Directory,'\',FileName,'NA_',num2str(NA) ,'SOFI',num2str(subFrame),'.mrc'],'w+');
elseif ifsparsedecon==false
    FID = fopen([Directory,'\',FileName,'NA_',num2str(NA) ,'SACD',num2str(subFrame),'.mrc'],'w+');   
else
    FID = fopen([Directory,'\',FileName,'NA_',num2str(NA) ,'SACD_Sparse',num2str(subFrame),'.mrc'],'w+');    
end

[FID,~] = WriteMRC_withoutHead(FID, rot90(SRimg2vis,-1));
fclose(FID);