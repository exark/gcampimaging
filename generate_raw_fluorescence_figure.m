function generate_raw_fluorescence_figure(image)

plotEnd= min([max(image.stimOffsets)+5], [image.numFrames]);
xaxisFrames=1:image.numFrames;

for i=1: size(image.CSsig,1)
fh=figure();
cellname=['cell ID ' num2str(i)];
baselineTextValue= ['Baseline: ' num2str(round(image.baseline(i)))];
contrastTextValue= ['Contrast: ' num2str(image.visStimParamFile.contrast)];

plot ([image.stimOnsets image.stimOnsets], [mean(image.CSsig(i,:))*.95 mean(image.CSsig(i,:))*1.2], 'LineWidth', 1, 'Color', [0.4 0.4 0.4])
hold on
plot ([image.stimOffsets image.stimOffsets], [mean(image.CSsig(i,:))*.95 mean(image.CSsig(i,:))*1.2], 'LineWidth', 1, 'Color', [0.8 0.8 0.8])
plot ([1:plotEnd],image.CSsig(i,1:plotEnd),  'LineWidth', 2,'Color','k')
plot ([xaxisFrames(image.stimOnsets-1)],image.CSsig(i,image.stimOnsets-1), 'image.')
plot ([xaxisFrames(image.stimOnsets-2)],image.CSsig(i,image.stimOnsets-2), 'image.')
plot ([xaxisFrames(image.stimOnsets)],image.CSsig(i,image.stimOnsets), 'image.')
hold off
title ({'Raw Fluorescence';cellname});
ylabel ('Arbitrary units')
xlabel ('frame number')
% Create textbox
annotation(fh,'textbox',...
    [0.678571428571429 0.833333333333336 0.214285714285713 0.0595238095238156],...
    'String',{baselineTextValue},...
    'FontSize',12,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'Color',[0.847058832645416 0.160784319043159 0]);
annotation(fh,'textbox',...
    [0.678928571428572 0.768095238095242 0.214285714285713 0.0595238095238156],...
    'String',{contrastTextValue},...
    'FontSize',12,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'Color',[0 0 0]);
ylim ([image.baseline(i)-50 max(image.CSsig(i,1:plotEnd)+25)]);
    for j= 1: size(image.visStimParamFile.driftAngle,2)        
     oriPresented= image.stimOrder(1,j);  
     place12OriArrows(oriPresented,j,fh); %calls a function to draw arrow of appropriate orientation
    end
end