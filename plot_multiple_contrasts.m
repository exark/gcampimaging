function [r100,r50,r25,r12,r6] = plot_multiple_contrasts

r100 = dlr_analyse_visStim;
r50 = dlr_analyse_visStim(r100.basePoints);
r25 = dlr_analyse_visStim(r100.basePoints);
r12 = dlr_analyse_visStim(r100.basePoints);
r6 = dlr_analyse_visStim(r100.basePoints);

figure()
for i=[r100, r50, r25, r12, r6]
    responseOrdered(:,1) = i.meanResponses(:,12);
    responseOrdered(:,2:13) = i.meanResponses(:,1:12);
    theta = 0:(2*pi)/12:2*pi;
    polar(theta, responseOrdered);
    hold on
end
