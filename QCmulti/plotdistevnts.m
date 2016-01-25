function plotdistevnts(cat1, cat2, dist, reg)
% This function produces figures related to the events matching in time but
% not location.  They include a map and histogram of the location residuals.
%
% Inputs -
%   cat1 - Catalog 1 information and data
%   cat2 - Catalog 2 information and data
%   dist - Different location event information
%   reg - Region of interest
%
% Output - NONE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Formatting variables for output
%
FormatSpec2 = '%-10s %-20s %-8s %-9s %-7s %-3s \n';
FormatSpec1 = '%-10s %-20s %-8s %-9s %-7s %-3s %-7s \n';
%
% Initiate Figure
%
figure
hold on
%
% Plot world map and region
%
plotworld
load('regions.mat');
ind = find(strcmp(region,reg));
poly = coord{ind,1};
plot(poly(:,1),poly(:,2),'Color',[1 1 1]*0.25,'LineWidth',2);
%
% Plot the corresponding events on the map with a dashed line connecting
% the end points.
%
for ii = 1 : size(dist.events1,1)
    h1 = plot([dist.events1(ii,3),dist.events2(ii,3)],[dist.events1(ii,2),dist.events2(ii,2)],'k--');
    h2 = plot(dist.events1(ii,3),dist.events1(ii,2),'r.','MarkerSize',12);
    h3 = plot(dist.events2(ii,3),dist.events2(ii,2),'b.','MarkerSize',12);
end
%
% Get minimum and maximum values for restricted axes
%
minlon = min(poly(:,1))-0.5;
maxlon = max(poly(:,1))+0.5;
minlat = min(poly(:,2))-0.5;
maxlat = max(poly(:,2))+1.0;
%
% Plot formatting
%
legend([h1, h2, h3],['N=',num2str(size(dist.events1,1))],cat1.name,cat2.name)
axis([minlon maxlon minlat maxlat])
midlat = (maxlat-minlat)/2;
set(gca,'DataAspectRatio',[1,cosd(midlat),1])
xlabel('Longitude','FontSize',14)
ylabel('Latitude','FontSize',15)
set(gca,'FontSize',15)
title(['Distance Residuals'],'FontSize',14)
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Print Results
%
% disp(['There are ',num2str(size(dist.events1,1)),' events with matching origin times '])
% disp('but different locations')
% fprintf(FormatSpec1,'Event ID', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag', 'Res(km)')
% for ii = 1 : size(dist.events1,1)
%     fprintf(FormatSpec1, dist.ids1{ii,1}, datestr(dist.events1(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(dist.events1(ii,2)),num2str(dist.events1(ii,3)),num2str(dist.events1(ii,4)),num2str(dist.events1(ii,5)),num2str(dist.events1(ii,6)))
%     fprintf(FormatSpec2, dist.ids1{ii,2}, datestr(dist.events2(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(dist.events2(ii,2)),num2str(dist.events2(ii,3)),num2str(dist.events2(ii,4)),num2str(dist.events2(ii,5)))
%     disp('--')
% end
% disp('----------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot histogram of residuals
%
figure
hold on
histogram(dist.events1(:,6))
%
% Figure formatting
%
xlabel(['Distance Residuals: ',cat1.name,'-',cat2.name],'FontSize',14)
ylabel('Count','FontSize',15)
set(gca,'FontSize',15)
title('Distance Residuals','FontSize',14)
axis tight
box on
hold off
drawnow
%
% End of function
%
end