function plotmagsevnts(cat1, cat2, mags, reg)
% This function produces figures related to the events differinf in magnitude
% They include a map and histogram of the lmagnitude residuals.
%
% Inputs -
%   cat1 - Catalog 1 information and data
%   cat2 - Catalog 2 information and data
%   mags - Different magnitude event information
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
%
% Plot Events on the map
%
h1 = plot(mags.cat1.Longitude,mags.cat1.Latitude,'.','Color',[1 1 1]);
h2 = plot(mags.cat1.Longitude,mags.cat1.Latitude,'r.');
h3 = plot(mags.cat2.Longitude,mags.cat2.Latitude,'b.');
%
% Restrict to Region of interest
% Get minimum and maximum values for restricted axes
%
load('regions.mat')
if strcmpi(reg,'all')
    poly(1,1) = min([cat1.data.Longitude;cat2.data.Longitude]);
    poly(2,1) = max([cat1.data.Longitude;cat2.data.Longitude]);
    poly(1,2) = min([cat1.data.Latitude;cat2.data.Latitude]);
    poly(2,2) = max([cat1.data.Latitude;cat2.data.Latitude]);
else
    ind = find(strcmpi(region,reg));
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
legend([h1,h2,h3],['N=',num2str(size(mags.cat1,1))],cat1.name,cat2.name)
axis([minlon maxlon minlat maxlat])
midlat = (maxlat+minlat)/2;
set(gca,'DataAspectRatio',[1,cosd(midlat),1])
xlabel('Longitude','FontSize',14)
ylabel('Latitude','FontSize',15)
set(gca,'FontSize',15)
title(['Magnitude residuals'],'FontSize',14)
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Print Results
%
% disp(['There are ',num2str(size(mags.events1,1)),' events with different magnitudes'])
% fprintf(FormatSpec1,'Catalog 1', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag', 'Res')
% for ii = 1 : size(mags.events1,1)
%     fprintf(FormatSpec1,mags.ids{ii,1},datestr(mags.events1(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(mags.events1(ii,2)),num2str(mags.events1(ii,3)),num2str(mags.events1(ii,4)),num2str(mags.events1(ii,5)),num2str(mags.events1(ii,6)));
%     fprintf(FormatSpec2,mags.ids{ii,2},datestr(mags.events2(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(mags.events2(ii,2)),num2str(mags.events2(ii,3)),num2str(mags.events2(ii,4)),num2str(mags.events2(ii,5)));
%     disp('--')
% end
% disp('----------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot histogram of residuals
%
delMag = mags.cat1.Mag-mags.cat2.Mag;
figure
hold on
histogram(delMag)
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
%
% End of function
%
end