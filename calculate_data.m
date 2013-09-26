function [new_image] = calculate_data(image)

new_image = image

%defining stim onset here:
[n,hout]=hist(new_image.PDm);
[~,inx]=max(n(2:end-1));
inx=inx+1; %since n(2:
stimLevel=max(hout(inx));
blankWLevel= max(new_image.PDm);
blankBLevel= min(new_image.PDm);

frameStimIndex= zeros(new_image.numFrames,1);

%lower left corner
indMax =find(new_image.PDm>blankWLevel-50);
frameTransitions1=find(abs(diff(new_image.PDm(indMax(1):end)))>2900); %500 %3200
% figure()
% plot(abs(diff(new_image.PDm(indMax(1):end))))
inxDoubleCount=find(diff(frameTransitions1)<2);
frameTransitions1(inxDoubleCount+1)=NaN;
frameTransitions1=frameTransitions1(isfinite(frameTransitions1));

frameTransitions1= frameTransitions1+ indMax(1)-1;
stimOnsets= frameTransitions1(1:2:numel(frameTransitions1));
stimOnsets=stimOnsets(1:12);  %change 12 if number of presentations is altered


for i=1:numel(stimOnsets)
    if (new_image.PDm(stimOnsets(i))/blankWLevel)*100 >98 || (new_image.PDm(stimOnsets(i))/blankBLevel)*100 <105
        stimOnsets(i)=stimOnsets(i)+1;
    end
end

stimOffsets= frameTransitions1(2:2:numel(frameTransitions1));
stimOffsets(end+1)= stimOnsets(end)+5;

new_image.stimOnsets= stimOnsets; %same for all cells
new_image.stimOffsets= stimOffsets; %same for all cells

% % defining baseline for each individual cell here:
for i= 1: size(new_image.CSsig,1)
    new_image.baseline(i)= (mean([new_image.CSsig(i,new_image.stimOnsets) new_image.CSsig(i,new_image.stimOnsets-1) new_image.CSsig(i,new_image.stimOnsets-2)]));
end

% % get vis stim parameters(general, same for all cells):
new_image.visStimParamFile=load ([new_image.mp new_image.mf]);
new_image.vsParamFilename= new_image.mf;
[new_image.stimOrder, new_image.stimulusParameters, ~]= loadAndDecodeVisStimMatFile (new_image.mp, new_image.mf);

% % deltaF/F
new_image.stimOrderIndex= zeros(size(new_image.CSsig,1),size(new_image.stimOnsets,1));
for i= 1: size(new_image.CSsig,1)
   count=1;
    for j=30:30:360        
        new_image.stimOrderIndex(i,count)=find(new_image.stimOrder(1,:)==j);
        count=count+1;
    end    
end

new_image.responseOrdered_MeanAmplitude= zeros(size(new_image.CSsig,1),12);
for i= 1: size(new_image.CSsig,1)
    for j=1:12
        new_image.responseOrdered_MeanAmplitude(i,j)=...
            mean( new_image.CSsig(i,new_image.stimOnsets(new_image.stimOrderIndex(i,j))+1:new_image.stimOnsets(new_image.stimOrderIndex(i,j))+5) )/ new_image.baseline(i);
    end
end

new_image.responseOrdered_localBaseine= zeros(size(new_image.CSsig,1),12);
for i= 1: size(new_image.CSsig,1)
    for j=1:12
        new_image.responseOrdered_localBaseine(i,j)=...
            mean( new_image.CSsig(i,new_image.stimOnsets(new_image.stimOrderIndex(i,j))+1:new_image.stimOnsets(new_image.stimOrderIndex(i,j))+5) )/ ...
            (mean([new_image.CSsig(i,new_image.stimOnsets) new_image.CSsig(i,new_image.stimOnsets-1) new_image.CSsig(i,new_image.stimOnsets-2)]));
    end
end


new_image.responseOrdered_Traces= zeros(12,15,size(new_image.CSsig,1));
% in case not enough frames were collected after last stim onset
if new_image.numFrames< new_image.stimOnsets(end)+12
    beep;
    disp('Padding, not enough frames collected')
    new_image.responseOrdered_Traces= zeros(12,15,new_image.stimOnsets(end)+12);
    for i=1:size(new_image.CSsig,1)
        new_image.CSsig(i,end:end+diff([new_image.stimOnsets(end) new_image.numFrames]+1))= new_image.baseline(i);
    end
end
%
for i= 1: size(new_image.CSsig,1)
    for j=1:12
        %j
        new_image.responseOrdered_Traces(j,1:15,i)=...
            ( new_image.CSsig(i,new_image.stimOnsets(new_image.stimOrderIndex(i,j))-2:new_image.stimOnsets(new_image.stimOrderIndex(i,j))+12) )/ new_image.baseline(i);
    end
end