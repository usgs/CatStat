function plotcatmap(catalog)
% This function creates a seismicity map for the catalog, including bounds 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
%         ** Hoping to add polygon for catalog as well
% Output: None

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

% plot quakes
figure
plot(catalog.data(:,3),catalog.data(:,2),'r.')
daspect([1,1,1]);
set(gca,'fontsize',15)
axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
hold on

% load, process, and plot coastline data
load ./Data/coastline.data
coastline(coastline == 99999) = NaN;
clat = coastline(:,2);
clon = coastline(:,1);
clon(abs(diff(clon))>180) = NaN;
plot(clon,clat,'k','linewidth',1)
xlabel('Longitude');
ylabel('Latitude');
title(catalog.name);
hold on

plot([minlon maxlon maxlon minlon minlon],[maxlat maxlat minlat minlat maxlat],'k');
%rectangle('Position',[minlon minlat abs(abs(maxlon)-abs(minlon)) abs(abs(maxlat)-abs(minlat))])

