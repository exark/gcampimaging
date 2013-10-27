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
the_title = header{1}{1}(1:end-1);
location=f(1:end-3);

stims=[0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330];

mkdir('Analysis');
cd ('Analysis');

for k=1:size(r100.meanResponses,1)
    fig = figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(4,5,1)
    set(gcf,'DefaultAxesColorOrder',[1 0 0])
    generate_labeled_figure(r100.image(1),k)
    title('100% Contrast')
    subplot(4,5,[11 16])
    osi=calc_osiSK(r100.meanResponses(k,:),stims);
    title(['100% Contrast, 1-CV=' num2str(osi)])
    ylabel('$\frac{F}{F_0}$','Interpreter', 'Latex','FontSize', 12)
    xlabel('Bar Orientation ($^\circ$)','Interpreter', 'Latex','FontSize', 12)
    generate_ordered_fluorescence_w_mean(r100,k,r100.baselineStdev)

    subplot(4,5,6)
    set(gcf,'DefaultAxesColorOrder',[0 .5 0])
    generate_labeled_figure(r50.image(1),k)
    title('50% Contrast')
    subplot(4,5,[12 17])
    generate_ordered_fluorescence_w_mean(r50,k,r50.baselineStdev)
    osi=calc_osiSK(r50.meanResponses(k,:),stims);
    title(['50% Contrast, 1-CV=' num2str(osi)])
    
    subplot(4,5,2)
    set(gcf,'DefaultAxesColorOrder',[0 0 1])
    generate_labeled_figure(r25.image(1),k)
    title('25% Contrast')
    subplot(4,5,[13 18])
    generate_ordered_fluorescence_w_mean(r25,k,r25.baselineStdev)
    osi=calc_osiSK(r25.meanResponses(k,:),stims);
    title(['25% Contrast, 1-CV=' num2str(osi)])

    subplot(4,5,7)
    set(gcf,'DefaultAxesColorOrder',[0.5 0 0.5])
    generate_labeled_figure(r12.image(1),k)
    title('12.5% Contrast')
    subplot(4,5,[14 19])
    generate_ordered_fluorescence_w_mean(r12,k,r12.baselineStdev)
    osi=calc_osiSK(r12.meanResponses(k,:),stims);
    title(['12.5% Contrast, 1-CV=' num2str(osi)])

    subplot(4,5,3)
    set(gcf,'DefaultAxesColorOrder',[0 0 0])
    generate_labeled_figure(r6.image(1),k)
    title('6.25% Contrast')
    subplot(4,5,[15 20])
    generate_ordered_fluorescence_w_mean(r6,k,r6.baselineStdev)
    osi=calc_osiSK(r6.meanResponses(k,:),stims);
    title(['6.25% Contrast, 1-CV=' num2str(osi)])
    
    subplot(4,5,[4,5,9,10])
    set(gcf,'DefaultAxesColorOrder',[1 0 0;0 .5 0;0 0 1; 0.5 0 0.5; 0 0 0;])
    for i=[r100, r50, r25, r12, r6]
        responseOrdered(:,1) = i.meanResponses(k,12);
        responseOrdered(:,2:13) = i.meanResponses(k,1:12);
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
    mtit([the_title ': Cell ' num2str(k)])
    tightfig
%     uncomment when you wanna save pngs
%     saveas(fig, [location '_cell' k '.png'], 'png');
end
sf = [the_title '_' location];
[sf,sp]= uiputfile('.mat', ['Save responses for image file: ' the_title], sf);
save(sf,'r100','r50','r25','r12','r6');
cd('..');

