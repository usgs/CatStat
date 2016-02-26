function [eqevents] = plotcatmap(catalog,reg)
% This function creates a seismicity map for the catalog, including bounds 
% Input: a structure containing catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
%         ** Hoping to add polygon for catalog as well
%
% Output: eqevents  A matrix of ONLY earthquakes from the original catalog
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Map of recorded catalog activity distinguished between earthquakes (red) and overlaying non earthquakes (blue).']);
%
% Finds indices where evtype is earthquake
%
eqevents = catalog.data(strcmp('earthquake',catalog.evtype),:);
%
% Finds indices where evtype is not earthquake
%
noneq = catalog.data(~strcmp('earthquake',catalog.evtype),:);
%
% Initialize Figure
%
figure
hold on
plotworld
%
% Plot earthquakes (red) and non-earthquake events (blue)
%
h1 = plot(eqevents(:,3),eqevents(:,2),'r.');
h2 = plot(noneq(:,3),noneq(:,2),'b.');
%
% Boundaries
%
if strcmpi(reg,'all')
    poly(1,1) = min(catalog.data(:,3));
    poly(2,1) = max(catalog.data(:,3)); 
    poly(1,2) = min(catalog.data(:,2));
    poly(2,2) = max(catalog.data(:,2));
else
    load('regions.mat')
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
if minlon < -170 & maxlon > 170 & maxlat < 79 & minlat > -60
    maxlon = -1*min(abs(catalog.data(:,3)));
    minlon = -180;
end
midlat = (maxlat + minlat)/2;
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
box on
hold off
drawnow
%
% End of function
%
end