function generate_ordered_fluorescence_w_mean(results_object)

%figure();
hold all

for i=1:4
responseOrdered(:,1)= results_object.image(i).responseOrdered_MeanAmplitude(:,12);
responseOrdered(:,2:13)= results_object.image(i).responseOrdered_MeanAmplitude(:,1:12);
plot(1:13,responseOrdered(:,1:13),'Color',[0 0 0]+0.6);
end

responseOrdered(:,1)= results_object.meanResponses(:,12);
responseOrdered(:,2:13)= results_object.meanResponses(:,1:12);
plot(1:13,responseOrdered(:,1:13),'-k','LineWidth',1.2);


set(gca,'XTick', 1:13);
set(gca,'XTickLabel', {'0', '30', '60', '90', '120', '150','180', '210', '240', '270', '300', '330', '0'});
hold off