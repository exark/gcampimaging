function generate_summary_figure

for i=1:size(image.CSsig,1);
    cellID=i;
cellIDstr=['cell ID ' num2str(cellID)];
x=[1:15; 17:17+14; 33:33+14; 48:48+14; 63:63+14; 77:77+14; 92:92+14; 107:107+14; 122:122+14; 137:137+14; 152:152+14; 167:167+14];
figure()
plot(x(1,:),image.responseOrdered_Traces(1,:,cellID))
hold on
for j=2:12,
    plot(x(j,:),image.responseOrdered_Traces(j,:,cellID))
    ylabel ('F/F0')
    xlabel('Degrees')
end
title (cellIDstr)
set(gca, 'XTick', [1 17 33 48 63 77 92 107 122 137 152 167]);
set(gca,'XTickLabel', {'30', '60', '90', '120', '150','180', '210', '240', '270', '300', '330', '0'});
end