function [r100,r50,r25,r12,r6] = plot_multiple_contrasts(pv)

[f, p] = uigetfile('.txt', 'Select the file describing the runs you want to analyze');

r100 = analyze_cell('100',p,f);
r50 = analyze_cell('50',p,f,r100.basePoints);
r25 = analyze_cell('25',p,f,r100.basePoints);
r12 = analyze_cell('12',p,f,r100.basePoints);
r6 = analyze_cell('6',p,f,r100.basePoints);

fid = fopen([p f]);
header = textscan(fid, '%s', 1);
fclose(fid);
the_title = header{1}{1}(1:end-1);
location=f(1:end-4);

stims=[0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330];

mkdir('Analysis');
cd ('Analysis');

labeled_fig = figure();
generate_labeled_figure(r100.image(1));
saveas(labeled_fig, [pv location '_labeled_figure.fig'],'fig');

for k=1:size(r100.meanResponses,1)
    fig = figure('units','normalized','outerposition',[0 0 1 1]);
    set(gcf,'DefaultAxesColorOrder',[1 0 0])
    subplot(2,6,1)
    xlabel('100% Contrast')
    generate_trace_figure_w_mean(r100,k)
    subplot(2,6,7)
    set(gcf,'DefaultAxesColorOrder',[1 0 0])
    subbedResponses=adjustValues(r100.meanResponses(k,:));
    osi=calc_osiSK(subbedResponses,stims);
    title(['100% Contrast, 1-CV=' num2str(osi)])
    ylabel('$\frac{F}{F_0}$','Interpreter', 'Latex','FontSize', 12)
    xlabel('Bar Orientation ($^\circ$)','Interpreter', 'Latex','FontSize', 12)
    generate_ordered_fluorescence_w_mean(r100,k)

    set(gcf,'DefaultAxesColorOrder',[0 .5 0])
    subplot(2,6,2)
    generate_trace_figure_w_mean(r50,k)
    xlabel('50% Contrast')
    subplot(2,6,8)
    set(gcf,'DefaultAxesColorOrder',[0 .5 0])
    generate_ordered_fluorescence_w_mean(r50,k)
    subbedResponses=adjustValues(r50.meanResponses(k,:));
    osi=calc_osiSK(subbedResponses,stims);
    title(['50% Contrast, 1-CV=' num2str(osi)])
    
    set(gcf,'DefaultAxesColorOrder',[0 0 1])
    subplot(2,6,3)
    generate_trace_figure_w_mean(r25,k)
    xlabel('25% Contrast')
    subplot(2,6,9)
    set(gcf,'DefaultAxesColorOrder',[0 0 1])
    generate_ordered_fluorescence_w_mean(r25,k)
    subbedResponses=adjustValues(r25.meanResponses(k,:));
    osi=calc_osiSK(subbedResponses,stims);
    title(['25% Contrast, 1-CV=' num2str(osi)])

    set(gcf,'DefaultAxesColorOrder',[0.5 0 0.5])
    subplot(2,6,4)
    generate_trace_figure_w_mean(r12,k)
    xlabel('12.5% Contrast')
    subplot(2,6,10)
    set(gcf,'DefaultAxesColorOrder',[0.5 0 0.5])
    generate_ordered_fluorescence_w_mean(r12,k)
    subbedResponses=adjustValues(r12.meanResponses(k,:));
    osi=calc_osiSK(subbedResponses,stims);
    title(['12.5% Contrast, 1-CV=' num2str(osi)])

    set(gcf,'DefaultAxesColorOrder',[0 0 0])
    subplot(2,6,5)
    generate_trace_figure_w_mean(r6,k)
    xlabel('6.25% Contrast')
    subplot(2,6,11)
    set(gcf,'DefaultAxesColorOrder',[0 0 0])
    generate_ordered_fluorescence_w_mean(r6,k)
    subbedResponses=adjustValues(r6.meanResponses(k,:));
    osi=calc_osiSK(subbedResponses,stims);
    title(['6.25% Contrast, 1-CV=' num2str(osi)])
    
    subplot(2,6,12)
    set(gcf,'DefaultAxesColorOrder',[1 0 0;0 .5 0;0 0 1; 0.5 0 0.5; 0 0 0;])
    for i=[r100, r50, r25, r12, r6]
        responseOrdered(:,1) = i.meanResponses(k,12);
        responseOrdered(:,2:13) = i.meanResponses(k,1:12);
        responseOrdered = adjustValues(responseOrdered);
        theta = 0:(2*pi)/12:2*pi;
        polar(theta, responseOrdered);
        hold all
    end
    hold off
    
    subplot(2,6,6)
    generate_labeled_figure(r100.image(1),k)
    
    tightfig
    mtit([the_title ': Cell ' num2str(k)])
    saveas(fig, [pv location '_cell' num2str(k) '.fig'], 'fig');
end
sf = [the_title '_' location];
[sf,sp]= uiputfile('.mat', ['Save responses for image file: ' the_title], sf);
save(sf,'r100','r50','r25','r12','r6');
cd('..');

end

function subbedResponses = adjustValues(input_values)

subbedResponses=zeros(1,12);
for i=1:length(input_values)
   subbedResponses(i) = input_values(i) - 1;
end
adjustment = abs(min(subbedResponses));
for i=1:length(subbedResponses)
    subbedResponses(i) = subbedResponses(i) + adjustment;
end
end

