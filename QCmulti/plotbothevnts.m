function plotbothevnts(cat1, cat2, both, reg)
% This function produces figures related to the events that have magnitude
% and depth residuals outside of tolerance.
%
% Inputs -
%   cat1 - Catalog 1 information and data
%   cat2 - Catalog 2 information and data
%   both - Events differing in depth and magnitude
%   reg - Region of interest
%
% Output - NONE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Formatting variables for output
%
FormatSpec1 = '%-10s %-20s %-8s %-9s %-7s %-3s %-7s %-7s\n';
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
%
% Plot Events on the map
%
h1 = plot(both.events1(:,3),both.events1(:,2),'.','Color',[1 1 1]);
h2 = plot(both.events1(:,3),both.events1(:,2),'r.');
h3 = plot(both.events2(:,3),both.events2(:,2),'b.');
%
% Restrict to Region of interest
% Get minimum and maximum values for restricted axes
%
load('regions.mat')
if strcmpi(reg,'all')
    poly(1,1) = min([cat1.data(:,3);cat2.data(:,3)]);
    poly(2,1) = max([cat1.data(:,3);cat2.data(:,3)]);
    poly(1,2) = min([cat1.data(:,2);cat2.data(:,2)]);
    poly(2,2) = max([cat1.data(:,2);cat2.data(:,2)]);
else
    ind = find(strcmp(region,reg));
    poly = coord{ind,1};
    %
    % Plot region
    %
    plot(poly(:,1),poly(:,2),'k--','LineWidth',2)
end
minlon = min(poly(:,1))-0.5;
maxlon = max(poly(:,1))+0.5;
minlat = min(poly(:,2))-0.5;
maxlat = max(poly(:,2))+1.0;
%
% Plot formatting
%
legend([h1,h2,h3],['N=',num2str(size(both.events1,1))],cat1.name,cat2.name)
axis([minlon maxlon minlat maxlat])
midlat = (maxlat+minlat)/2;
set(gca,'DataAspectRatio',[1,cosd(midlat),1])
xlabel('Longitude','FontSize',14)
ylabel('Latitude','FontSize',15)
set(gca,'FontSize',15)
title(['Depth and Magnitude residuals'],'FontSize',14)
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Print Results
%
disp(['There are ',num2str(size(both.events1,1)),' events with different depths'])
% fprintf(FormatSpec1,'Catalog 1', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag', 'DepRes','MagRes')
% for ii = 1 : size(both.events1,1)
%     fprintf(FormatSpec1,both.ids{ii,1},datestr(both.events1(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(both.events1(ii,2)),num2str(both.events1(ii,3)),num2str(both.events1(ii,4)),num2str(both.events1(ii,5)),num2str(both.events1(ii,6)), num2str(both.events1(ii,7)))
%     fprintf(FormatSpec2,both.ids{ii,2},datestr(both.events2(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(both.events2(ii,2)),num2str(both.events2(ii,3)),num2str(both.events2(ii,4)),num2str(both.events2(ii,5)));
%     disp('--')
% end
disp('----------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot histogram of depth residuals
%
figure
hold on
histogram(both.events1(:,6))
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot histogram of magnitude residuals
%
figure
hold on
histogram(both.events1(:,7))
%
% Figure formatting
%
xlabel(['Magnitude Residuals: ',cat1.name,'-',cat2.name],'FontSize',14)
ylabel('Count','FontSize',15)
set(gca,'FontSize',15)
title('Magnitude Residuals','FontSize',14)
axis tight
box on
hold off
drawnow
end

    