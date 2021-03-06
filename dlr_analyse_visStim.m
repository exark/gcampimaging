%created by Dario Ringach, used in Kuhlman Nature 2013 to analyze data aquired by Elaine Tring at UCLA. Modified July2013 sk
%see readme txt file in this folder
%Data aquired using ScanImage
%Currently requires 256x256 tiff images.  Interpolate to resize if
%necessary.
function [r] = dlr_analyse_visStim(varargin)
% varargs can  be of the form:
% dlr_analyse_visStim(basepoints)
% dlr_analyse_visStim(f1, p1, f2, p2, f3, p3, f4, p4)
% dlr_analyse_visStim(basepoints, f1, p1, f2, p2, f3, p3, f4, p4)
originaldirectory=pwd;

genFigures = 0;
numTrials = 4;

if nargin == 1
    basePoints = varargin{1};
elseif nargin == 8
    f = cell(1,8);
    p = cell(1,8);
    f{1} = varargin{1};
    p{1} = varargin{2};
    f{2} = varargin{3};
    p{2} = varargin{4};
    f{3} = varargin{5};
    p{3} = varargin{6};
    f{4} = varargin{7};
    p{4} = varargin{8};
elseif nargin == 9
    basePoints = varargin{1};
    f = cell(1,4);
    p = cell(1,4);
    f{1} = varargin{2};
    p{1} = varargin{3};
    f{2} = varargin{4};
    p{2} = varargin{5};
    f{3} = varargin{6};
    p{3} = varargin{7};
    f{4} = varargin{8};
    p{4} = varargin{9};
end

if exist('f','var')
    if exist('basePoints','var')
        [r.image(1), ~] = load_image_with_visStim(f{1}, p{1}, basePoints);
        r.basePoints = basePoints;
    else
        [r.image(1), r.basePoints] = load_image_with_visStim(f{1}, p{1});
    end
else
    [r.image(1), r.basePoints] = load_image_with_visStim;
end

[r.image(1).stimOnsets, ...
r.image(1).stimOffsets, ...
r.image(1).baseline, ...
r.image(1).visStimParamFile, ...
r.image(1).vsParamFilename, ...
r.image(1).stimOrder, ...
r.image(1).stimulusParameters, ...
r.image(1).stimOrderIndex, ...
r.image(1).responseOrdered_MeanAmplitude, ...
r.image(1).responseOrdered_localBaseline, ...
r.image(1).responseOrdered_Traces] = calculate_data(r.image(1));

% %plot raw fluorescence traces for each cell:
if genFigures
    generate_labeled_figure(r.image(1));
    generate_onsets_figure(r.image(1));
    generate_raw_fluorescence_figure(r.image(1))
    generate_ordered_fluorescence_figure(r.image(1))
end % if genFigures

% multiple trial analysis starts here
for i=2:numTrials
    if exist('f','var')
        [new_image, ~] = load_image_with_visStim(f{i},p{i}, r.basePoints);
    else
        [new_image, ~] = load_image_with_visStim(r.basePoints);
    end
    
    [new_image.stimOnsets, ...
    new_image.stimOffsets, ...
    new_image.baseline, ...
    new_image.visStimParamFile, ...
    new_image.vsParamFilename, ...
    new_image.stimOrder, ...
    new_image.stimulusParameters, ...
    new_image.stimOrderIndex, ...
    new_image.responseOrdered_MeanAmplitude, ...
    new_image.responseOrdered_localBaseline, ...
    new_image.responseOrdered_Traces] = calculate_data(new_image);

    %this plots stimonsets.

	r.image(i) = new_image;

    % %plot raw fluorescence traces for each cell:

    if genFigures
        generate_labeled_figure(r.image(i));
        generate_onsets_figure(r.image(i));
        generate_raw_fluorescence_figure(r.image(i))
        generate_ordered_fluorescence_figure(r.image(i))
    end % if genFigures
end

% generate mean response from all trials, for all cells
numCells = size(r.image(1).CSsig,1);
r.meanResponses = zeros(numCells,12);
r.baselines = zeros(numCells,12,numTrials);
r.baselineStdev = zeros(numCells,1);
for i=1:numCells
    concatted_ordered_responses = cat(1,r.image(1).responseOrdered_MeanAmplitude(i,:), ...
        r.image(2).responseOrdered_MeanAmplitude(i,:), ...
        r.image(3).responseOrdered_MeanAmplitude(i,:), ...
        r.image(4).responseOrdered_MeanAmplitude(i,:));
    r.meanResponses(i,:) = mean(concatted_ordered_responses);
    for j=1:numTrials
        r.baselines(i,:,j) = r.image(j).responseOrdered_localBaseline(i,:);
    end
    r.baselineStdev(i) = std(reshape(r.baselines(i,:,:),1,12*numTrials));
end

% mkdir('Analysis');
% cd ('Analysis');
% indexUS= strfind(r.image(1).f, '_');
% indexUS_last=indexUS(end);
% filenameprefix1= r.image(1).f(1:indexUS_last+3);
% contrastStrValue= [num2str(r.image(1).visStimParamFile.contrast*100)];
% sf = [filenameprefix1 '-' contrastStrValue];
% 
% [sf,sp]= uiputfile('.mat', ['Save responses for image file: ' filenameprefix1], sf);
% save(sf,'r');

cd (originaldirectory);








