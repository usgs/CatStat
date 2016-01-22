function plotdepevnts(cat1, cat2, dep, reg)
% This function produces figures related to the events that different in 
% depth, but were similar in time and location.
% The include a map and histogram of the depth residuals.
%
% Inputs -
%   cat1 - Catalog 1 information and data
%   cat2 - Catalog 2 information and data
%   dep - Events differing in depth but similar in origin time and location
%   reg - Region of interest
%
% Output - NONE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Formatting variables for output
%
FormatSpec1 = '%-10s %-20s %-8s %-9s %-7s %-3s %-7s \n';
FormatSpec2 = '%-10s %-20s %-8s %-9s %-7s %-3s \n';
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
% Plot Events on the map
%
h1 = plot(dep.events1(:,3),dep.events1(:,2),'Color',[1 1 1]);
h2 = plot(dep.events1(:,3),dep.events1(:,2),'r.');
h3 = plot(dep.events2(:,3),dep.events2(:,2),'b.');
%
% Get minimum and maximum values for restricted axes
%
minlon = min(poly(:,1))-0.5;
maxlon = max(poly(:,1))+0.5;
minlat = min(poly(:,2))-0.5;
maxlat = max(poly(:,2))+0.5;
%
% Plot formatting
%
legend([h1,h2,h3],['N=',num2str(size(dep.events1,1))],cat1.name,cat2.name)
axis([minlon maxlon minlat maxlat])
midlat = (maxlat-minlat)/2;
set(gca,'DataAspectRatio',[1,cosd(midlat),1])
xlabel('Longitude','FontSize',14)
ylabel('Latitude','FontSize',15)
set(gca,'FontSize',15)
title(['Depth residuals'],'FontSize',14)
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Print Results
%
%disp(['There are ',num2str(size(dep.events1,1)),' events with different depths'])
%fprintf(FormatSpec1,'Catalog 1', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag', 'Res(km)')
%for ii = 1 : size(dep.events1,1)
%    fprintf(FormatSpec1,dep.ids{ii,1},datestr(dep.events1(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(dep.events1(ii,2)),num2str(dep.events1(ii,3)),num2str(dep.events1(ii,4)),num2str(dep.events1(ii,5)),num2str(dep.events1(ii,6)))
%    fprintf(FormatSpec2,dep.ids{ii,2},datestr(dep.events2(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(dep.events2(ii,2)),num2str(dep.events2(ii,3)),num2str(dep.events2(ii,4)),num2str(dep.events2(ii,5)));
%    disp('--')
%end
%disp('----------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot histogram of residuals
%
figure
hold on
histogram(dep.events1(:,6))
%
% Figure formatting
%
xlabel(['Depth Residuals: ',cat1.name,'-',cat2.name],'FontSize',14)
ylabel('Count','FontSize',15)
set(gca,'FontSize',15)
title('Depth Residuals','FontSize',14)
axis tight
box on
hold off
drawnow
end

    