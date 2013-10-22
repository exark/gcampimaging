function generate_ordered_fluorescence_w_mean(results_object, cellID, baselineStdev)

%figure();
hold all

for i=1:4
responseOrdered(:,1)= results_object.image(i).responseOrdered_MeanAmplitude(cellID,12);
responseOrdered(:,2:13)= results_object.image(i).responseOrdered_MeanAmplitude(cellID,1:12);
plot(1:13,responseOrdered(:,1:13),'Color',[0 0 0]+0.6);
end

responseOrdered(:,1)= results_object.meanResponses(cellID,12);
responseOrdered(:,2:13)= results_object.meanResponses(cellID,1:12);
plot(1:13,responseOrdered(:,1:13),'-k','LineWidth',1.2);
plot(0:14,ones(1,15) * baselineStdev(cellID) + 1, '--k');
plot(0:14,ones(1,15) * baselineStdev(cellID) * 2 + 1, '--k');
plot(0:14,ones(1,15) * baselineStdev(cellID) * 3 + 1, '--k');


set(gca,'XTick', 1:13);
set(gca,'XTickLabel', {'0', '30', '60', '90', '120', '150','180', '210', '240', '270', '300', '330', '0'});
hold off