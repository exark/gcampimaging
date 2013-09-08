function [stimulusOrder, decodingMatrix] = decodeOrder_sk(stimulusType, driftAngle, spatialFrequency, temporalFrequency, contrast, nExperimentRepeats, randomSeed, randomOrder)
% for DGB: stimulusType 1
% given the original contrast, sf, tf, and driftAngles
% as well as the number of repeats and randomSeed, function decodeOrder
% reproduces the order of the stimuli for that experiment

% for DB: stimulusType 4
% given the original

% since we changed driftangle to be saved without sorting -- sort it here

%sk !!! should be commented out??
%driftAngle = sort(driftAngle);  % sk July12 trouble! I think that this should be commented out for my purposes, commented out July 12, 2010
%sk !!!!!!

switch(stimulusType)
    case 1 % DGB
        % number from 1 to max number of combinations
        
        stimuli = 1:(numel(contrast) * numel(spatialFrequency) * numel(temporalFrequency) * numel(driftAngle));
        
        % generates decoding matrix
        decodingMatrix = contrast';
        temp = reshape(repmat(temporalFrequency,[size(decodingMatrix,1) 1]),[numel(temporalFrequency)*size(decodingMatrix,1) 1]); %#ok<NBRAK>
        decodingMatrix = [temp repmat(decodingMatrix,[numel(temporalFrequency) 1])]; clear temp
        temp = reshape(repmat(spatialFrequency,[size(decodingMatrix,1) 1]),[numel(spatialFrequency)*size(decodingMatrix,1) 1]); %#ok<NBRAK>
        decodingMatrix = [temp repmat(decodingMatrix,[numel(spatialFrequency) 1])]; clear temp
        temp = reshape(repmat(driftAngle,[size(decodingMatrix,1) 1]),[numel(driftAngle)*size(decodingMatrix,1) 1]);
        decodingMatrix = [temp repmat(decodingMatrix,[numel(driftAngle) 1])]; clear temp
        % end decoding matrix
        
        % for i = 1:numel(stimuli)
        %         currentDriftAngle = decodingMatrix(i,1);
        %         currentSpatialFrequency = decodingMatrix(i,2);
        %         currentTemporalFrequency = decodingMatrix(i,3);
        %         currentContrast = decodingMatrix(i,4);
        %
        % stimuli(i) = i;
        % grating with that angle, etc.
        %
        % end
        %
        
       if randomOrder      
        rand('seed',randomSeed) % reseed the rdg.  because this is the same seed used before the presentation was made, any rand()/randperm calls made after it will be identical
        stimulusOrder = zeros(1,nExperimentRepeats*length(stimuli));
        for i = 0:nExperimentRepeats-1
            % stimuli is randomized for every repeat
            stimulusOrder(i*length(stimuli)+1:(i+1)*length(stimuli)) = randperm(length(stimuli));
        end
        else
           stimulusOrder = repmat(1:length(stimuli),[1 nExperimentRepeats]);
        end
        
        
        
    case 4 % DB
        decodingMatrix = driftAngle';
        
        stimuli = 1:numel(driftAngle);
        
        % randomized
        rand('seed',randomSeed);
        stimulusOrder = zeros(1, nExperimentRepeats*length(stimuli));
        for i = 0:nExperimentRepeats - 1
            % stimuli is randomized for every repeat
            stimulusOrder(i*length(stimuli)+1:(i+1)*length(stimuli)) = randperm(length(stimuli));
        end
        
end % switch

end % function decodeOrder

function p = randperm(n)

% randperm  Random permutation.
%
% p = randperm(n) returns a random permutation of 1:n.

[ignore, p] = sort(rand(1, n));

end