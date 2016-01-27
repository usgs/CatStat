function [eqevents] = plotcatmap(catalog)
% This function creates a seismicity map for the catalog, including bounds 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
%         ** Hoping to add polygon for catalog as well
% Output: eqevents

disp(['Map of recorded catalog activity distinguished between earthquakes (red) and overlaying non earthquakes (blue).']);
ind1 = find(strcmp('earthquake',catalog.evtype)); % Finds index of evtype that is earthquake
ind2 = find(~strcmp('earthquake',catalog.evtype)); % Finds index of evtype that is earthquake
%
%
%
eqevents = catalog.data(ind1,:); %creates matrix of all earthquakes
noneq = catalog.data(ind2,:);
%
% Make figure
%
figure
hold on
plotworld
%
% Plot earthquakes and non-earthquake events
%
h1 = plot(eqevents(:,3),eqevents(:,2),'r.');
h2 = plot(noneq(:,3),noneq(:,2),'b.');
%
% Boundaries
%
maxlat = max(catalog.data(:,2)); 
minlat = min(catalog.data(:,2));
if sign(minlat) == -1
    midlat = (maxlat + minlat) / 2;
else
    midlat = (maxlat - minlat)/2;
end
maxlon = max(catalog.data(:,3));
minlon = min(catalog.data(:,3));
%
% Format Options
%
if isempty(h2)
    legend(h1,'Earthquakes','Location','NorthOutside')
else
    legend([h1, h2],'Earthquakes','Other Events','Location','NorthOutside')
end
ylabel('Latitude')
xlabel('Longitude')
axis([minlon maxlon minlat maxlat]);
set(gca,'DataAspectRatio',[1,cosd(midlat),1])
set(gca,'fontsize',15)
hold off
drawnow
end
