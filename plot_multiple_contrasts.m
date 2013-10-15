function [r100,r50,r25,r12,r6] = plot_multiple_contrasts

[f, p] = uigetfile('.txt', 'Select the file describing the runs you want to analyze');

r100 = analyze_cell('100',p,f);
r50 = analyze_cell('50',p,f,r100.basePoints);
r25 = analyze_cell('25',p,f,r100.basePoints);
r12 = analyze_cell('12',p,f,r100.basePoints);
r6 = analyze_cell('6',p,f,r100.basePoints);

fid = fopen([p f]);
header = textscan(fid, '%s', 1);
fclose(fid);
the_title = header{1}{1};

figure()
% title(the_title, 'FontWeight','bold')
subplot(2,6,1)
generate_labeled_figure(r100.image(1))
subplot(2,6,7)
generate_ordered_fluorescence_w_mean(r100)
subplot(2,6,2)
generate_labeled_figure(r50.image(1))
subplot(2,6,8)
generate_ordered_fluorescence_w_mean(r50)
subplot(2,6,3)
generate_labeled_figure(r25.image(1))
subplot(2,6,9)
generate_ordered_fluorescence_w_mean(r25)
subplot(2,6,4)
generate_labeled_figure(r12.image(1))
subplot(2,6,10)
generate_ordered_fluorescence_w_mean(r12)
subplot(2,6,5)
generate_labeled_figure(r6.image(1))
subplot(2,6,11)
generate_ordered_fluorescence_w_mean(r6)
subplot(2,6,12)
for i=[r100, r50, r25, r12, r6]
    responseOrdered(:,1) = i.meanResponses(:,12);
    responseOrdered(:,2:13) = i.meanResponses(:,1:12);
    for j=1:length(responseOrdered)
        responseOrdered(j) = responseOrdered(j)-1;
    end
    adjustment = min(responseOrdered);
    for j=1:length(responseOrdered)
        responseOrdered(j) = responseOrdered(j)+adjustment;
    end
    theta = 0:(2*pi)/12:2*pi;
    polar(theta, responseOrdered);
    hold all
end
hold off
tightfig

% mkdir('Analysis');
% cd ('Analysis');
% sf = the_title;
% [sf,sp]= uiputfile('.mat', ['Save responses for image file: ' the_title], sf);
% save(sf,'r100','r50','r25','r12','r6');

