%uses decodeOrder_sk.m
%only set up to do case drifting gratings

function [stimOrder, stimulusParameters, numPresWithin1Run, p, f]= loadVisStimMatFile

[f,p,i] = uigetfile('.mat','Pick a .mat vis stim parameter file.');
stimulusParameters = load ([p f]);
fprintf('Loaded selected vis stim parameter file: %s.\n', f);

stimulusParameters.nExperimentRepeats

%stimulusParameters.randomOrder=0;  %can remove once get correct version of randOrder .mat variable saved!
if strfind(f, 'sa_2010'), stimulusParameters.randomOrder=0; disp('!! changed randomOrder to 0');end

stimulusOrderIndx=[];
stimulusCodes = {'driftingGratingsBattery', 'bandFilteredWhiteNoise', 'flashingCheckerboard', 'driftingBars', 'manualDriftingBars', 'sparseNoise'};
decodingKey={'angle','spatial freq', 'temp freq', 'contrast'};
numRuns= stimulusParameters.nExperimentRepeats;

% %% based on reconstructOrder.m, uses decodeOrder_sk.m
        
        stimulusCode = strmatch(stimulusParameters.stimulusType, stimulusCodes);
          
        disp(['Stimulus type = ' stimulusParameters.stimulusType ]);
       
        switch (stimulusParameters.stimulusType)
            
            case 'driftingGratingsBattery'
                
                waves = {'sine' 'square'};
                
                
                if ~isfield(stimulusParameters, 'driftAngle')
                    stimulusParameters.driftAngle = [];
                end
                
                if ~isfield(stimulusParameters, 'spatialFrequency')
                    stimulusParameters.spatialFrequency = [];
                end
                
                if ~isfield(stimulusParameters, 'temporalFrequency')
                    stimulusParameters.temporalFrequency = [];
                end
                
                if ~isfield(stimulusParameters, 'contrast')
                    stimulusParameters.contrast = [];
                end
                
                if ~isfield(stimulusParameters, 'nExperimentRepeats')
                    stimulusParameters.nExperimentRepeats = [];
                end
                
                driftAngle = stimulusParameters.driftAngle;
                spatialFrequency = stimulusParameters.spatialFrequency;
                temporalFrequency = stimulusParameters.temporalFrequency;
                contrast = stimulusParameters.contrast;
                nrepeats = stimulusParameters.nExperimentRepeats;
                
                [stimulusOrderIndx, decodingMatrix] = decodeOrder_sk(stimulusCode, driftAngle, spatialFrequency, temporalFrequency, contrast, nrepeats, stimulusParameters.randomSeed,stimulusParameters.randomOrder);
                numPresWithin1Run= length(decodingMatrix(:,1));               
                
                % row1 angles               
                stimOrder(1,1:numPresWithin1Run*numRuns) = decodingMatrix(stimulusOrderIndx,1);
                stimOrder(stimOrder(1,1:numPresWithin1Run*numRuns)==0)=360;
                
                % row2 spatial freq
                stimOrder(2,1:numPresWithin1Run*numRuns) = decodingMatrix(stimulusOrderIndx,2);
                
                % row3 temporal freq
                stimOrder(3,1:numPresWithin1Run*numRuns) = decodingMatrix(stimulusOrderIndx,3);
                
                % row4 contrast
                stimOrder(4,1:numPresWithin1Run*numRuns) = decodingMatrix(stimulusOrderIndx,4);
                
%                 disp([' Angle order = ' num2str(stimOrder(1,1:numPresWithin1Run)) ]);
%                 disp([' Spatial frequency order = ' num2str(stimOrder(2,1:numPresWithin1Run)) ]);
%                 disp([' Temporal frequency order = ' num2str(stimOrder(3,1:numPresWithin1Run)) ]);
%                 disp([' Contrast order = ' num2str(stimOrder(4,1:numPresWithin1Run)) ]);
%                 disp([' Waves (sine/square) = ' waves{2*stimulusParameters.dutyCycle+1}]);
%                 
                
            
            
            case 'driftingBars'
                
                if stimulusParameters.randomOrder % if randomized order
                    rand('seed',stimulusParameters.randomSeed); % seed the RNG
                    orientationOrder = [];
                    for i = 1:stimulusParameters.nExperimentRepeats
                        orientationOrder = [orientationOrder randperm(numel(stimulusParameters.driftAngle))]; %#ok<AGROW>
                    end; clear i
                else
                    % note: nStimuliPerBlank got phased out in june 2009.  if
                    % there are errors here it's possible an old file with
                    % nStimuliPerBlank was loaded.
                    orientationOrder = repmat(1:numel(stimulusParameters.driftAngle),[1 stimulusParameters.nExperimentRepeats]);
                end
                if isstruct(stimulusParameters.mask)
                    if stimulusParameters.mask.motion
                        disp(['Masked with a checkerboard (continuous locations), stimulus frequency = ' num2str(stimulusParameters.mask.stimulusFrequency) ', board rotation at ' num2str(stimulusParameters.mask.orientation) ' degrees, spatial frequency = ' num2str(stimulusParameters.mask.spatialFrequency)]);
                    end
                    temp = [];
                    % for i = 1:numel(orientationOrder)
                    %     temp = [temp stimulusParameters.maskSeries{orientationOrder(i)}]; %#ok<AGROW>
                    % end; clear i
                    % orientationOrder = temp; clear temp
                end
                
                disp(['Bars were presented at the following orientations: ' num2str(stimulusParameters.driftAngle(orientationOrder))]);
                disp(['All bars were ' num2str(stimulusParameters.barWidth) ' degrees wide and each bar took ' num2str(stimulusParameters.stimulusDuration) ' seconds to cross the screen.']);
                disp([num2str(stimulusParameters.blankDuration) ' second(s) of blank screen separated each bar.']);
            
                output = [];
                if nargout > 0
                    output{1} = orientationOrder;
                end
            
            case 'bandFilteredWhiteNoise'
                
                
                
                
                
                disp('Reconstruction not completed yet.');
           
            case 'flashingCheckerboard'
                disp('Not done yet')
           
            case 'manualDriftingBars'
                
                for i=1:size(stimulusParameters.dataTable,2)
                    disp(['Stimulus number ' num2str(i) ' _______']);
                    if strcmp(stimulusParameters.dataTable{1,i},'Bar')
                        % bar
                        disp([stimulusParameters.dataTable{1,i} ', ' num2str(stimulusParameters.dataTable{4,i}) ' degrees wide'])
                        disp([num2str(stimulusParameters.dataTable{2,i}) ' s duration']);
                        disp([num2str(stimulusParameters.dataTable{3,i}) ' degree orientation ']);
                        disp(['Drifting in the (Cartesian) ' num2str(stimulusParameters.dataTable{5,i}) ' direction']);
                    else
                        % blank
                        disp([stimulusParameters.dataTable{1,i}]);
                        disp([num2str(stimulusParameters.dataTable{2,i}) ' s duration']);
                    end
                end
            case 'sparseNoise'
                
                disp(['Number of dots = ' num2str(stimulusParameters.gs^2), ' i.e. a square with ' num2str(stimulusParameters.gs) ' to each side']);
                disp(['The grid covers ' num2str(stimulusParameters.rfsize) ' degrees']);
                disp(['Each dot was presented for ' num2str(stimulusParameters.stimdur) ' ms with a ' num2str(stimulusParameters.isi) ' ISI,' ...
                    ' so the presentation was ' num2str(stimulusParameters.isi*stimulusParameters.stimdur*stimulusParameters.gs^2*2/1000) ' seconds long.']);
                stimulusParameters.prezParameters
                stimulusParameters.sn_map
                
        end % switchcase




%%%%%



% if sum(diff(decodingMatrix(:,2)))==0,
%     fileinfo{2}= ['cpd ' num2str(decodingMatrix(1,2))];
% else
%     fileinfo{2}= ['cpd ' num2str(decodingMatrix(:,2)')];
%     
% end
% 
% if sum(diff(decodingMatrix(:,3)))==0,
%     fileinfo{3}= ['tfreq ' num2str(decodingMatrix(1,3))];
% else
%     fileinfo{3}= ['tfreq ' num2str(decodingMatrix(:,3)')];
%     
% end
% %[stimulusOrderIndx, decodingMatrix] = decodeOrder_sk(stimulusCode, driftAngle, spatialFrequency, temporalFrequency, contrast, stimulusParameters.nExperimentRepeats, stimulusParameters.randomSeed, stimulusParameters.randomOrder);








end