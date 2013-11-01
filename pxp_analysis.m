%created by Dario Ringach, used in Kuhlman Nature 2013 to analyze data aquired by Elaine Tring at UCLA. Modified July2013 sk
%see readme txt file in this folder
%Data aquired using ScanImage
%Currently requires 256x256 tiff images.  Interpolate to resize if
%necessary.
function [r] = pxp_analysis
thresh=0.1;
sensitivity=1.5;
multMagnitude=10;

originaldirectory=pwd;

genFigures=0;

GCaMPch=1;
REDch=2;
PDch=3;
ballTRACKch=4;


[f,p]  = uigetfile('*.tif','Select your 3 or 4 chan file');            % generalized to 4 channels Aug3 2013    


% [mf,mp]  = uigetfile('*.mat','Select your .mat vis stim file');
% mf

%select .mat vis stim file with suggestion:
DirInfoImage=dir(f);
DirInfoVSF=dir('*.ana');

for i=1:size(DirInfoVSF,1)
    ad(i)=abs(diff([DirInfoImage.datenum DirInfoVSF(i).datenum]));
end
[~,indexMin]= min(ad); 
mfSuggest=DirInfoVSF(indexMin).name;
r.mf = mfSuggest;
r.mp = p;

%read in header info of image file
hgeneric=imfinfo([p f]);
header=hgeneric(1).ImageDescription;
header=parseHeader(header);
%ScanImage specifc:
numFrames=header.acq.numberOfFrames;
pxPline=header.acq.pixelsPerLine;
linePfram=header.acq.linesPerFrame;
numChans=header.acq.numberOfChannelsAcquire;
zoomFactor=header.acq.zoomFactor;
frameRate=header.acq.frameRate;

CS = zeros(numFrames,256,256);  %CS- calcium signal channel
PD = zeros(256,256,numFrames);  % photodiode channel, feedback from vis stim monitor

for(i=1:numFrames)
    CS(i,:,:)=imread(f,'Index',GCaMPch+(i-1)*numChans);  %use 1+(i-1)*3 if first channel aquired is calcium signal and three channels were aquired
    PD(:,:,i) = imread(f,'Index',PDch+(i-1)*numChans);
end
PDm= squeeze(mean(mean(PD)));

CSm = squeeze(mean(CS,1));
CSm = (CSm-min(CSm(:)))/(max(CSm(:))-min(CSm(:)));
CSma = imadjust(CSm);

%Generate masks from normalized calcium channel
CSmsk = CSma(:,:)>=thresh;

%Use non-zero parts of mask to select spots for analysis
[y, x] = find(CSmsk);

%x and y can now be used to find the corresponding pixel in CSma. For
%example, to find the actual position of the 400th pixel being analyzed,
%look at the coordinates given by x(400),y(400) in CSma.

for (j=1:numFrames)
    imgCS = squeeze(CS(j,:,:));
    for (i=1:length(x))
        CSsig(i, j) = imgCS(x(i),y(i));
    end
end

r.filename = hgeneric(1, 1).Filename;
r.CSmsk = CSmsk;
r.CSimage = CSma;
r.CSsig= CSsig;
r.PDm=PDm;
r.numFrames=numFrames;
r.x = x;
r.y = y;

[r.stimOnsets, ...
r.stimOffsets, ...
r.baseline, ...
r.visStimParamFile, ...
r.vsParamFilename, ...
r.stimOrder, ...
r.stimulusParameters, ...
r.stimOrderIndex, ...
r.responseOrdered_MeanAmplitude, ...
r.responseOrdered_localBaseline, ...
r.responseOrdered_Traces] = calculate_data(r);

% figure()
% plot(r.PDm);
% hold on
% plot(r.stimOnsets,r.PDm(r.stimOnsets), 'r*')
% plot(r.stimOffsets,r.PDm(r.stimOffsets), 'g*')
% hold off
% title StimOnsets

%determine orientation preference for each pixel
r.orientationPrefs = cell(size(r.CSsig,1),1);
stimuli={'0' '30' '60' '90' '120' '150' '180' '210' '240' '270' '300' '330'};
for i=1:size(r.CSsig,1)
    responses = r.responseOrdered_MeanAmplitude(i,:);
    [val, index] = max(responses);
    if val >= sensitivity*(r.baseline(i)/100)
        r.orientationPrefs(i) = stimuli(index);
    else
        r.orientationPrefs(i) = {'Null'};
    end
end

r.pxp_map = zeros(256,256,3,'uint8');

for i=1:size(r.CSsig,1)
    orientation_color = 0;
    orientation = r.orientationPrefs(i);
    if strcmp(orientation,'Null')
        orientation_color=[0 0 0];
    elseif strcmp(orientation,stimuli(1))
        orientation_color=[159 238 0];
    elseif strcmp(orientation,stimuli(2))
        orientation_color=[134 179 45];
    elseif strcmp(orientation,stimuli(3))
        orientation_color=[103 155 0];
    elseif strcmp(orientation,stimuli(4))
        orientation_color=[201 247 111];
    elseif strcmp(orientation,stimuli(5))
        orientation_color=[255 0 0];
    elseif strcmp(orientation,stimuli(6))
        orientation_color=[191 48 48];
    elseif strcmp(orientation,stimuli(7))
        orientation_color=[166 0 0];
    elseif strcmp(orientation,stimuli(8))
        orientation_color=[255 115 115];
    elseif strcmp(orientation,stimuli(9))
        orientation_color=[113 9 170];
    elseif strcmp(orientation,stimuli(10))
        orientation_color=[95 37 128];
    elseif strcmp(orientation,stimuli(11))
        orientation_color=[72 3 111];
    else
        orientation_color=[173 102 213];
    end
    r.pxp_map(r.y(i),r.x(i),:) = orientation_color;
end

figure()
image(r.pxp_map);
axis off;
axis image;
% mkdir('Analysis');
% cd ('Analysis');
% indexUS= strfind(f, '_');
% indexUS_last=indexUS(end);
% filenameprefix1= f(1:indexUS_last+3);
% contrastStrValue= [num2str(r.visStimParamFile.contrast*100)];
% sf = [filenameprefix1 '-' contrastStrValue];
% 
% [sf,sp]= uiputfile('.mat', ['Save responses for image file: ' filenameprefix1], sf);
% save(sf,'r');

% cd (originaldirectory);








