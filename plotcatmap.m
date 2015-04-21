function plotcatmap(sortcsv)
% This function creates a seismicity map for the catalog, including bounds 
% Input: Sorted catalog matrix - hoping to add polygon as well
% Output: None

maxlat = max(sortcsv(:,2)); 
minlat = min(sortcsv(:,2));     
maxlon = max(sortcsv(:,3));     
minlon = min(sortcsv(:,3));
latbuf = 0.1*(maxlat-minlat);
lonbuf = 0.1*(maxlon-minlon);

%maplonmin = minlon - 5;
maplonmin = max(minlon-lonbuf,-180);
maplonmax = min(maxlon+lonbuf,180);
maplatmin = max(minlat-latbuf,-90);
maplatmax = min(maxlat+latbuf,90);

% plot quakes
plot(sortcsv(:,3),sortcsv(:,2),'r.')
daspect([1,1,1]);
set(gca,'fontsize',15)
axis([maplonmin maplonmax maplatmin maplatmax]);
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
hold on

plot([maplonmin maplonmax maplonmax maplonmin maplonmin],[maplatmax maplatmax maplatmin maplatmin maplatmax],'k');
%rectangle('Position',[minlon minlat abs(abs(maxlon)-abs(minlon)) abs(abs(maxlat)-abs(minlat))])

