function [r100,r50,r25,r12,r6] = plot_multiple_contrasts

[f, p] = uigetfile('.txt', 'Select the file describing the runs you want to analyze');

r100 = analyze_cell('100',p,f);
r50 = analyze_cell('50',p,f,r100.basePoints);
r25 = analyze_cell('25',p,f,r100.basePoints);
r12 = analyze_cell('12',p,f,r100.basePoints);
r6 = analyze_cell('6',p,f,r100.basePoints);

figure()
subplot(2,4,1)
generate_labeled_figure(r100.image(1))
subplot(2,4,2)
for i=[r100, r50, r25, r12, r6]
    responseOrdered(:,1) = i.meanResponses(:,12);
    responseOrdered(:,2:13) = i.meanResponses(:,1:12);
    theta = 0:(2*pi)/12:2*pi;
    polar(theta, responseOrdered);
    hold all
end
hold off
subplot(2,4,3)
generate_ordered_fluorescence_w_mean(r100)
subplot(2,4,4)
generate_ordered_fluorescence_w_mean(r50)
subplot(2,4,5)
generate_ordered_fluorescence_w_mean(r25)
subplot(2,4,6)
generate_ordered_fluorescence_w_mean(r12)
subplot(2,4,7)
generate_ordered_fluorescence_w_mean(r6)

