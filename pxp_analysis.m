%created by Dario Ringach, used in Kuhlman Nature 2013 to analyze data aquired by Elaine Tring at UCLA. Modified July2013 sk
%see readme txt file in this folder
%Data aquired using ScanImage
%Currently requires 256x256 tiff images.  Interpolate to resize if
%necessary.
function [r] = pxp_analysis
originaldirectory=pwd;

genFigures=0;

GCaMPch=1;
REDch=2;
PDch=3;
ballTRACKch=4;

thresh=0.1;
multMagnitude=10;


[f,p]  = uigetfile('*.tif','Select your 3 or 4 chan file');            % generalized to 4 channels Aug3 2013    


% [mf,mp]  = uigetfile('*.mat','Select your .mat vis stim file');
% mf

%select .mat vis stim file with suggestion:
dir('*.mat');
DirInfoImage=dir(f);
DirInfoVSF=dir('*.mat');

for i=1:size(DirInfoVSF,1)
    ad(i)=abs(diff([DirInfoImage.datenum DirInfoVSF(i).datenum]));
end
[~,indexMin]= min(ad); 
mfSuggest=DirInfoVSF(indexMin).name;
[mf,mp]  = uigetfile(mfSuggest,'Select your .mat vis stim file');


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
R = zeros(numFrames,256,256); %R- red channel
PD = zeros(256,256,numFrames);  % photodiode channel, feedback from vis stim monitor

for(i=1:numFrames)
    CS(i,:,:)=imread(f,'Index',GCaMPch+(i-1)*numChans);  %use 1+(i-1)*3 if first channel aquired is calcium signal and three channels were aquired
    R(i,:,:)=imread(f,'Index',REDch+(i-1)*numChans); %1+(i-1)*3 is becuase three channels were aquired
    PD(:,:,i) = imread(f,'Index',PDch+(i-1)*numChans);
end
PDm= squeeze(mean(mean(PD)));

CSm = squeeze(mean(CS,1));
CSm = (CSm-min(CSm(:)))/(max(CSm(:))-min(CSm(:)));
CSma = imadjust(CSm);

Rm = squeeze(mean(R,1));
Rm = (Rm-min(Rm(:)))/(max(Rm(:))-min(Rm(:)));
Rma = imadjust(Rm);

%Generate maks from normalized calcium channel
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
r.mask = CSmsk;
r.CSimage = CSma;
r.CSsig= CSsig;
r.PDm=PDm;
r.numFrames=numFrames;
r.x = x;
r.y = y;

% figure()
% set(gca,'XDir','reverse')
% imshow(r.CSimage)
% hold on
% numcells= size(x,1);
%     for i=1:numcells
%         newX = x(i);
%         newY = y(i);
%         plot(newX,newY, '.')
%         set(gca,'YDir','reverse')
%         cellID=num2str(i);
%         %text(newX-6,y(1), cellID,'FontSize', 16,'FontWeight','bold','Color',[1 0.694117647058824 0.392156862745098]);
%         hold on
%     end
%     hold off
%     ylim([0 256])
%     xlim([0 256])



% % defining stim onset here:

[n,hout]=hist(r.PDm);
[~,inx]=max(n(2:end-1));
inx=inx+1; %since n(2:
stimLevel=max(hout(inx));
blankWLevel= max(r.PDm);
blankBLevel= min(r.PDm);


frameStimIndex= zeros(numFrames,1);

%lower left corner
indMax =find(r.PDm>blankWLevel-50);
frameTransitions1=find(abs(diff(r.PDm(indMax(1):end)))>2900); %500 %3200
% figure()
% plot(abs(diff(r.PDm(indMax(1):end))))
inxDoubleCount=find(diff(frameTransitions1)<2);
frameTransitions1(inxDoubleCount+1)=NaN;
frameTransitions1=frameTransitions1(isfinite(frameTransitions1));

frameTransitions1= frameTransitions1+ indMax(1)-1;
stimOnsets= frameTransitions1(1:2:numel(frameTransitions1));
stimOnsets=stimOnsets(1:12);  %change 12 if number of presentations is altered


for i=1:numel(stimOnsets)
    if (r.PDm(stimOnsets(i))/blankWLevel)*100 >98 || (r.PDm(stimOnsets(i))/blankBLevel)*100 <105
        stimOnsets(i)=stimOnsets(i)+1;
    end
end

stimOffsets= frameTransitions1(2:2:numel(frameTransitions1));
stimOffsets(end+1)= stimOnsets(end)+5;

r.stimOnsets= stimOnsets; %same for all cells
r.stimOffsets= stimOffsets; %same for all cells



% figure()
% plot(r.PDm);
% hold on
% plot(r.stimOnsets,r.PDm(r.stimOnsets), 'r*')
% plot(r.stimOffsets,r.PDm(r.stimOffsets), 'g*')
% hold off
% title StimOnsets


% % defining baseline for each individual cell here:
for i= 1: size(r.CSsig,1)
    r.baseline(i)= (mean([r.CSsig(i,r.stimOnsets) r.CSsig(i,r.stimOnsets-1) r.CSsig(i,r.stimOnsets-2)]));
end

% % get vis stim parameters(general, same for all cells):
r.visStimParamFile=load ([mp mf]);
r.vsParamFilename= mf;
[r.stimOrder, r.stimulusParameters, ~]= loadAndDecodeVisStimMatFile (mp, mf);

% % deltaF/F
r.stimOrderIndex= zeros(size(r.CSsig,1),size(r.stimOnsets,1));
for i= 1: size(r.CSsig,1)
   count=1;
    for j=30:30:360        
        r.stimOrderIndex(i,count)=find(r.stimOrder(1,:)==j);
        count=count+1;
    end    
end

r.responseOrdered_MeanAmplitude= zeros(size(r.CSsig,1),12);
for i= 1: size(r.CSsig,1)
    for j=1:12
        r.responseOrdered_MeanAmplitude(i,j)=...
            mean( r.CSsig(i,r.stimOnsets(r.stimOrderIndex(i,j))+1:r.stimOnsets(r.stimOrderIndex(i,j))+5) )/ r.baseline(i);
    end
end

r.responseOrdered_localBaseine= zeros(size(r.CSsig,1),12);
for i= 1: size(r.CSsig,1)
    for j=1:12
        r.responseOrdered_localBaseine(i,j)=...
            mean( r.CSsig(i,r.stimOnsets(r.stimOrderIndex(i,j))+1:r.stimOnsets(r.stimOrderIndex(i,j))+5) )/ ...
            (mean([r.CSsig(i,r.stimOnsets) r.CSsig(i,r.stimOnsets-1) r.CSsig(i,r.stimOnsets-2)]));
    end
end

%determine orientation preference for each pixel
r.orientationPrefs = cell(size(r.CSsig,1),1);
stimuli={'0' '30' '60' '90' '120' '150' '180' '210' '240' '270' '300' '330'};
for i=1:size(r.CSsig,1)
    responses = r.responseOrdered_MeanAmplitude(i,:);
    [val, index] = max(responses);
    r.orientationPrefs(i) = stimuli(index);
end

r.pxp_map = zeros(256,256,3,'uint8');

for i=1:size(r.CSsig,1)
    orientation_color = 0;
    orientation = r.orientationPrefs(i);
    if strcmp(orientation,stimuli(1))
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
    r.pxp_map(r.x(i),r.y(i),:) = orientation_color;
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








