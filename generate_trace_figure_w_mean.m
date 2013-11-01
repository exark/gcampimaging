function generate_trace_figure_w_mean(results_object, cellID)

meanResponses = zeros(12,15);
for i=1:12
    for j=1:15
        concatted=cat(1,...
            results_object.image(1).responseOrdered_Traces(i,j,cellID),...
            results_object.image(2).responseOrdered_Traces(i,j,cellID),...
            results_object.image(3).responseOrdered_Traces(i,j,cellID),...
            results_object.image(4).responseOrdered_Traces(i,j,cellID));
        response = mean(concatted);
        meanResponses(i,j) = response;
    end
end

hold on
for l=1:size(results_object.image,2)
    image = results_object.image(l);
    for i=1:size(image.CSsig,1);
        x=[1:15; 17:17+14; 33:33+14; 48:48+14; 63:63+14; 77:77+14; 92:92+14; 107:107+14; 122:122+14; 137:137+14; 152:152+14; 167:167+14];
        for j=1:12
            plot(x(j,:),image.responseOrdered_Traces(j,:,cellID),'Color',[0 0 0]+0.6)
        end
    end
end

x=[1:15; 17:17+14; 33:33+14; 48:48+14; 63:63+14; 77:77+14; 92:92+14; 107:107+14; 122:122+14; 137:137+14; 152:152+14; 167:167+14];
for j=1:12
    plot(x(j,:),meanResponses(j,:),'LineWidth',1.2);
end

plot(0:180,ones(1,181) * results_object.baselineStdev(cellID) + 1, '--k');
plot(0:180,ones(1,181) * results_object.baselineStdev(cellID) * 2 + 1, '--k');
plot(0:180,ones(1,181) * results_object.baselineStdev(cellID) * 3 + 1, '--k');

set(gca, 'XTick', [1 17 33 48 63 77 92 107 122 137 152 167]);
set(gca,'XTickLabel', {'0','30', '60', '90', '120', '150','180', '210', '240', '270', '300', '330'});
hold off