function [stimOnsets, ...
          stimOffsets, ...
          baseline, ...
          visStimParamFile, ...
          vsParamFilename, ...
          stimOrder, ...
          stimulusParameters, ...
          stimOrderIndex, ...
          responseOrdered_MeanAmplitude, ...
          responseOrdered_localBaseline, ...
          responseOrdered_Traces] = calculate_data(image)

%defining stim onset here:
[n,hout]=hist(image.PDm);
[~,inx]=max(n(2:end-1));
inx=inx+1; %since n(2:
stimLevel=max(hout(inx));
blankWLevel= max(image.PDm);
blankBLevel= min(image.PDm);

frameStimIndex= zeros(image.numFrames,1);

%lower left corner
indMax =find(image.PDm>blankWLevel-50);
frameTransitions1=find(abs(diff(image.PDm(indMax(1):end)))>2900); %500 %3200
% figure()
% plot(abs(diff(image.PDm(indMax(1):end))))
inxDoubleCount=find(diff(frameTransitions1)<2);
frameTransitions1(inxDoubleCount+1)=NaN;
frameTransitions1=frameTransitions1(isfinite(frameTransitions1));

frameTransitions1= frameTransitions1+ indMax(1)-1;
stimOnsets= frameTransitions1(1:2:numel(frameTransitions1));
stimOnsets=stimOnsets(1:12);  %change 12 if number of presentations is altered


for i=1:numel(stimOnsets)
    if (image.PDm(stimOnsets(i))/blankWLevel)*100 >98 || (image.PDm(stimOnsets(i))/blankBLevel)*100 <105
        stimOnsets(i)=stimOnsets(i)+1;
    end
end

stimOffsets= frameTransitions1(2:2:numel(frameTransitions1));
stimOffsets(end+1)= stimOnsets(end)+5;

% % defining baseline for each individual cell here:
baseline = zeros(size(image.CSsig,1));
for i= 1: size(image.CSsig,1)
    baseline(i)= (mean([image.CSsig(i,stimOnsets) image.CSsig(i,stimOnsets-1) image.CSsig(i,stimOnsets-2)]));
end

% % get vis stim parameters(general, same for all cells):
visStimParamFile=load ([image.mp image.mf]);
vsParamFilename= image.mf;
[stimOrder, stimulusParameters, ~]= loadAndDecodeVisStimMatFile (image.mp, image.mf);

% % deltaF/F
stimOrderIndex= zeros(size(image.CSsig,1),size(stimOnsets,1));
for i= 1: size(image.CSsig,1)
   count=1;
    for j=30:30:360        
        stimOrderIndex(i,count)=find(stimOrder(1,:)==j);
        count=count+1;
    end    
end

responseOrdered_MeanAmplitude= zeros(size(image.CSsig,1),12);
for i= 1: size(image.CSsig,1)
    for j=1:12
        responseOrdered_MeanAmplitude(i,j)=...
            mean(image.CSsig(i,stimOnsets(stimOrderIndex(i,j))+1:stimOnsets(stimOrderIndex(i,j))+5) )/baseline(i);
    end
end

responseOrdered_localBaseline= zeros(size(image.CSsig,1),12);
for i= 1: size(image.CSsig,1)
    for j=1:12
        responseOrdered_localBaseline(i,j)=...
            mean(image.CSsig(i,stimOnsets(stimOrderIndex(i,j))+1:stimOnsets(stimOrderIndex(i,j))+5) )/ ...
            (mean([image.CSsig(i,stimOnsets) image.CSsig(i,stimOnsets-1) image.CSsig(i,stimOnsets-2)]));
    end
end


responseOrdered_Traces = zeros(12,15,size(image.CSsig,1));
% in case not enough frames were collected after last stim onset
if image.numFrames<stimOnsets(end)+12
    beep;
    disp('Padding, not enough frames collected')
    responseOrdered_Traces=zeros(12,15,stimOnsets(end)+12);
    for i=1:size(image.CSsig,1)
        image.CSsig(i,end:end+diff([stimOnsets(end) image.numFrames]+1))= baseline(i);
    end
end

for i= 1: size(image.CSsig,1)
    for j=1:12
        %j
        responseOrdered_Traces(j,1:15,i)=...
            (image.CSsig(i,stimOnsets(stimOrderIndex(i,j))-2:stimOnsets(stimOrderIndex(i,j))+12))/baseline(i);
    end
end