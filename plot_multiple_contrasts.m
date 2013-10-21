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
suptitle(the_title(1:end-1), 'FontWeight','bold')
subplot(4,5,1)
generate_labeled_figure(r100.image(1))
title('100% Contrast')
subplot(4,5,[11 16])
title('100% Contrast')
ylabel('$\frac{F}{F_0}$','Interpreter', 'Latex','FontSize', 24)
xlabel('Bar Orientation ($^\circ$)','Interpreter', 'Latex','FontSize', 24)
generate_ordered_fluorescence_w_mean(r100)

subplot(4,5,6)
generate_labeled_figure(r50.image(1))
title('50% Contrast')
subplot(4,5,[12 17])
generate_ordered_fluorescence_w_mean(r50)
title('50% Contrast')

subplot(4,5,2)
generate_labeled_figure(r25.image(1))
title('25% Contrast')
subplot(4,5,[13 18])
generate_ordered_fluorescence_w_mean(r25)
title('25% Contrast')

subplot(4,5,7)
generate_labeled_figure(r12.image(1))
title('12.5% Contrast')
subplot(4,5,[14 19])
generate_ordered_fluorescence_w_mean(r12)
title('12.5% Contrast')

subplot(4,5,3)
generate_labeled_figure(r6.image(1))
title('6.25% Contrast')
subplot(4,5,[15 20])
generate_ordered_fluorescence_w_mean(r6)
title('6.25% Contrast')

subplot(4,5,[4,5,9,10])
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

