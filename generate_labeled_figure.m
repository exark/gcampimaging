function [] = generate_labeled_figure(image, varargin)
% generate_labeled_figure(image) - figure with all cells labeled
% generate_labeled_figure(image, cellID) - figure with only labeled cell
%   displayed

%figure()
set(gca,'XDir','reverse')
imshow(image.CSma)
numCells = size(image.CSsig,1);
mask = image.CSmsk;
hold on
if nargin == 1
    for i=1:numCells
         [y,x]=find(mask==i); 
         plot(x(1:6:end),y(1:6:end), '.')
         set(gca,'YDir','reverse')
         cellID=num2str(i);
         text(x(1)-6,y(1), cellID,'FontSize', 16,'FontWeight','bold','Color',[1 0.694117647058824 0.392156862745098]);
         hold on
    end
else nargin == 2
     i = varargin{1};
     [y,x]=find(mask==i); 
     plot(x(1:6:end),y(1:6:end), '.')
     set(gca,'YDir','reverse')
     cellID=num2str(i);
     text(x(1)-6,y(1), cellID,'FontSize', 16,'FontWeight','bold','Color',[1 0.694117647058824 0.392156862745098]);
     hold on
end
    hold off
    ylim([0 256])
    xlim([0 256])
end