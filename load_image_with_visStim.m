function [image] = load_image_with_visStim(varargin)

GCaMPch=1;
REDch=2;
PDch=3;
ballTRACKch=4;

if nargin < 2
    [f, p]  = uigetfile('*.tif','Select your 3 or 4 chan file');            % generalized to 4 channels Aug3 2013
else
    f = varargin{1};
    p = varargin{2};
end

%select .mat vis stim file with suggestion:
DirInfoImage=dir(f);
DirInfoVSF=dir('*.mat');

for i=1:size(DirInfoVSF,1)
    ad(i)=abs(diff([DirInfoImage.datenum DirInfoVSF(i).datenum]));
end
[~,indexMin]= min(ad); 
mfSuggest=DirInfoVSF(indexMin).name;
%[mf,mp]  = uigetfile(mfSuggest,'Select your .mat vis stim file');

image.f = f;
image.p = p;
image.mf = mfSuggest;
image.mp = p;

%read in header info of image file
hgeneric=imfinfo([p f]);
header=hgeneric(1).ImageDescription;
header=parseHeader(header);
%ScanImage specifc:
image.numFrames=header.acq.numberOfFrames;
image.pxPline=header.acq.pixelsPerLine;
image.linePfram=header.acq.linesPerFrame;
image.numChans=header.acq.numberOfChannelsAcquire;
image.zoomFactor=header.acq.zoomFactor;
image.frameRate=header.acq.frameRate;

image.CS = zeros(image.numFrames,256,256);  %CS- calcium signal channel
image.R = zeros(image.numFrames,256,256); %R- red channel
image.PD = zeros(256,256,image.numFrames);  % photodiode channel, feedback from vis stim monitor

for(i=1:image.numFrames)
    image.CS(i,:,:)=imread(f,'Index',GCaMPch+(i-1)*image.numChans);  %use 1+(i-1)*3 if first channel aquired is calcium signal and three channels were aquired
    R(i,:,:)=imread(f,'Index',REDch+(i-1)*image.numChans); %1+(i-1)*3 is becuase three channels were aquired
    PD(:,:,i) = imread(f,'Index',PDch+(i-1)*image.numChans);
end
image.PDm= squeeze(mean(mean(PD)));

CSm = squeeze(mean(image.CS,1));
image.CSm = (CSm-min(CSm(:)))/(max(CSm(:))-min(CSm(:)));
image.CSma = imadjust(image.CSm);

Rm = squeeze(mean(R,1));
image.Rm = (Rm-min(Rm(:)))/(max(Rm(:))-min(Rm(:)));
image.Rma = imadjust(image.Rm);

image.fuse=imfuse(image.CSma,image.Rma, 'falsecolor', 'colorchannels', [2,1,0]);
end