function generate_ordered_fluorescence_figure(image)

figure();
responseOrdered(:,1)= image.responseOrdered_MeanAmplitude(:,12);
responseOrdered(:,2:13)= image.responseOrdered_MeanAmplitude(:,1:12);
plot(1:13,responseOrdered(:,1:13));
set(gca,'XTick', 1:13);
set(gca,'XTickLabel', {'0', '30', '60', '90', '120', '150','180', '210', '240', '270', '300', '330', '0'});