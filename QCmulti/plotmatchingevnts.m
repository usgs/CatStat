function plotmatchingevnts(cat1, cat2, matching, reg)
% This function produces figures related to the matching events.  They
% include a map and histograms of the magnitude and depth distributions as
% well as of the magnitude, depth, time, and location residuals.
%
% Inputs -
%   cat1 - Catalog 1 information and data
%   cat2 - Catalog 2 information and data
%   matching - Matching event information
%   reg - Region of interest
%
% Output - NONE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Initiate figure
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
plot(poly(:,1),poly(:,2),'k--','LineWidth',2);
%
% Plot matching events from catalog 1 and 2
% Ghost plot for information in legend
% 
h1 = plot(matching.data(:,3),matching.data(:,2),'Color',[1 1 1]);
h2 = plot(matching.data(:,3),matching.data(:,2),'r.');
h3 = plot(matching.data2(:,3),matching.data2(:,2),'b.');
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
axis([minlon maxlon minlat maxlat])
midlat = (maxlat-minlat)/2;
set(gca,'DataAspectRatio',[1,cosd(midlat),1])
xlabel('Longitude','FontSize',14)
ylabel('Latitude','FontSize',15)
set(gca,'FontSize',15)
legend([h1, h2, h3],['N=',num2str(size(matching.data,1))],cat1.name,cat2.name)
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Histograms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Magnitude Distribution
%
figure
hold on
histogram(matching.data(:,5))
%
%Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel('Magnitude','FontSize',15)
title('Magnitudes for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Depth Distribution
%
figure
hold on
histogram(matching.data(:,4))
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel('Depth (km)','FontSize',15)
title('Depths for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Time Residuals [86400 seconds in 1 day]
%
figure
hold on
histogram(matching.data(:,9)*86400)
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Time Residuals (s)',': ',cat1.name,'-',cat2.name],'FontSize',15)
title('Time Residuals for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Location (Distance Residuals)
%
figure
hold on
histogram(matching.data(:,6))
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Distance Residuals (km)',': ',cat1.name,'-',cat2.name],'FontSize',15)
title('Distance Residuals for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Magnitude Residuals
%
figure
hold on
histogram(matching.data(:,8))
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Magnitude Residuals',': ',cat1.name,'-',cat2.name],'FontSize',15)
title('Magnitude Residuals for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Depth Distribution
%
figure
hold on
histogram(matching.data(:,7))
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Depth Residuals (km)',': ',cat1.name,'-',cat2.name],'FontSize',15)
title(['Depth Residuals for Matching Events'],'FontSize',15)
axis tight
box on
hold off
drawnow
%
% End of Function
%
end
