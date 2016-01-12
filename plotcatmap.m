function [eqevents] = plotcatmap(catalog)
% This function creates a seismicity map for the catalog, including bounds 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
%         ** Hoping to add polygon for catalog as well
% Output: None

disp(['Map of recorded catalog activity distinguished between earthquakes (red) and overlaying non earthquakes (blue).']);

maxlon = max(catalog.data(:,3));     
minlon = min(catalog.data(:,3));

if minlon < -170 && maxlon > 170
    
    for index = 1:length(catalog.data(:,3))
        if catalog.data(index,3) < 0
             catalog.data(index,3) = (catalog.data(index,3) + 361);
        end
    end
    
    load ./Data/coastline.data
    coastline(coastline == 99999) = NaN;
    clat = coastline(:,2);
    clon = coastline(:,1);
    
    for index = 1:length(clon(:,1))
        if clon(index,1) < 0
             clon(index,1) = (clon(index,1) + 361);
        end
    end
    
    clon(abs(diff(clon))>360) = NaN;
    
    maxlat = max(catalog.data(:,2)); 
    minlat = min(catalog.data(:,2));  
    maxlon = max(catalog.data(:,3));
    minlon = min(catalog.data(:,3));
    latbuf = 0.1*(maxlat-minlat);
    lonbuf = 0.1*(maxlon-minlon);
    
    mapminlon = max(minlon-lonbuf,0);
    mapmaxlon = min(maxlon+lonbuf,360);
    mapminlat = max(minlat-latbuf,-90);
    mapmaxlat = min(maxlat+latbuf,90);

    index = find(strcmp('earthquake',catalog.evtype)); % Finds index of evtype that is earthquake
    eqevents = catalog.data(index(:,1),:); %creates matrix of all earthquakes

    for ii = 1:length(index)
        row = index(ii,1); % changes first cell to nan to later remove earthquakes from cat.data (temporary)
        catalog.data(row,1) = NaN; 
    end

    catalog.data(isnan(catalog.data(:,1)),:) = []; % removes all earthquakes

    % plot quakes
    figure
    plot(eqevents(:,3),eqevents(:,2),'r.')
    hold on
    plot(catalog.data(:,3),catalog.data(:,2),'b.')
    daspect([1,1,1]);
    set(gca,'fontsize',15)
    axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
    hold on

    % plot coastline data
    plot(clon,clat,'k','linewidth',1)
    xlabel('Longitude');
    ylabel('Latitude');
    title(catalog.name);
    hold on
    
    % plot([minlon maxlon maxlon minlon minlon],[maxlat maxlat minlat minlat maxlat],'k--'); %Seismicity extent
    % plot([(-156+361) (-164+361) (-169+361) (-169+361) (-140+361) (-140+361) (-156+361)],[55 59 63 71 71 57 55],'k--'); %AK
    
else
    maxlat = max(catalog.data(:,2)); 
    minlat = min(catalog.data(:,2));     
    maxlon = max(catalog.data(:,3));     
    minlon = min(catalog.data(:,3));
    latbuf = 0.1*(maxlat-minlat);
    lonbuf = 0.1*(maxlon-minlon);

%mapminlon = minlon - 5;
mapminlon = max(minlon-lonbuf,-180);
mapmaxlon = min(maxlon+lonbuf,180);
mapminlat = max(minlat-latbuf,-90);
mapmaxlat = min(maxlat+latbuf,90);

index = find(strcmp('earthquake',catalog.evtype)); % Finds index of evtype that is earthquake
eqevents = catalog.data(index(:,1),:); %creates matrix of all earthquakes

for ii = 1:length(index)
    row = index(ii,1);
    catalog.data(row,1) = NaN; % changes all earthquakes to NaN in first cell
end

catalog.data(isnan(catalog.data(:,1)),:) = []; % removes all earthquakes

% plot quakes
figure
plot(eqevents(:,3),eqevents(:,2),'r.')
hold on
plot(catalog.data(:,3),catalog.data(:,2),'b.')
daspect([1,1,1]);
set(gca,'fontsize',15)
axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
hold on

% load, process, and plot coastline data
[tmppath,tmpname,tmpext] = fileparts(which('QCreport'));
tmpcmd = ['load ',tmppath,'/Data/coastline.data']; 
eval(tmpcmd)
clear tmppath tmpname tmpext tmpcmd
coastline(coastline == 99999) = NaN;
clat = coastline(:,2);
clon = coastline(:,1);
clon(abs(diff(clon))>180) = NaN;
plot(clon,clat,'k','linewidth',1)
xlabel('Longitude');
ylabel('Latitude');
title(catalog.name);
hold on

% plot([minlon maxlon maxlon minlon minlon],[maxlat maxlat minlat minlat maxlat],'k--'); %Seismicity extent
% plot([-114.017 -114.799 -114.817 -114.815 -114.818 -114.816 -114.807 -114.802 -114.807 -114.813 -114.814 -114.81 -114.806 -114.807 -114.795 -114.794 -114.793 -114.8 -114.81 -114.817 -114.819 -114.805 -115.806 -114.803 -114.801 -114.802 -114.809 -114.811 -114.809 -114.801 -114.793 -114.784 -114.783 -114.767 -114.764 -114.755 -114.746 -114.742 -114.724 -119.219 -121.25 -117.76 -114 -114.017],[32.351 32.488 32.495 32.501 32.507 32.511 32.509 32.512 32.515 32.519 32.525 32.531 32.54 32.547 32.553 32.56 32.568 32.561 32.557 32.56 32.567 32.575 32.582 32.586 32.591 32.595 32.602 32.617 32.622 32.626 32.625 32.626 32.633 32.643 32.651 32.661 32.676 32.684 32.717 32.324 34.5 37.43 34.5 32.251],'k--'); %CI
% plot([-155.667 -156.167 -156.5 -155.917 -155.25 -154.917 -154.75 -155 -155.667],[18.75 19.167 20 20.333 20.25 20 19.5 18.833 18.75],'k--'); %HV
% plot([-71 -76.3 -77.25 -77.25 -81 -81 -75 -72.5 -73.25 -73.25 -73.48 -73.55 -73.48 -73.72 -73.65 -73.6 -71.85 -71.75 -69 -71],[38 38 38.35 39 39 43.2 46.5 46.5 45 42.75 42.05 41.3 41.22 41.1 41.01 40.95 41.3 41 41 38],'k--'); %LD
% plot([-111.333 -113 -116.05 -115 -113 -109.5 -109.5 -110 -111.333 -111.333],[44.5 44.5 47.95 48.5 48.5 46 45.167 45.167 45.167 44.5],'k--'); %MB
% plot([-121.25 -126 -126 -125 -120 -120 -117.76 -121.25],[34.5 40 42 42 42 39 37.43 34.5],'k--'); %NC
% plot([-80.263 -81.473 -85.226 -85.891 -88.416 -88.62 -86.68 -82.191 -81 -77.25 -77.25 -76.3 -75.4 -75.582 -79.655 -81.094 -79.829 -80.263],[24.76 24.911 30.047 33.481 34.027 36.627 37.627 37.255 39 39 38.35 38 38 35.953 32.223 30.738 26.981 24.76],'k--'); %SE
% plot([-93.5 -93.5 -91.5 -85 -85 -86.68 -88.62 -88.416 -93.5],[34 38 40 40 38.8 37.627 36.627 34.027 34],'k--'); %NM
% plot([-114 -117.76 -120 -120 -114.25 -114.25 -114 -114],[34.5 37.43 39 42 42 36.75 36.75 34.5],'k--'); %NN
% plot([-63.5 -69 -69 -63.5 -63.5],[17 17 20 20 17],'k--'); %PR
% plot([-108.75 -114.25 -114.25 -108.75 -108.75],[36.75 36.75 42.5 42.5 36.75],'k--'); %UU
% plot([-117 -120 -125 -125 -124.6 -125 -123.4 -123.3 -117 -117],[42 42 42 43 44.5 48.5 48.3 48.95 49 42],'k--'); %UW

end
