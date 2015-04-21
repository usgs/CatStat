function plotcatmap(sortcsv)
% This function creates a seismicity map for the catalog, including bounds 
% Input: Sorted catalog matrix - hoping to add polygon as well
% Output: None

maxlat = max(sortcsv(:,2)); 
minlat = min(sortcsv(:,2));     
maxlon = max(sortcsv(:,3));     
minlon = min(sortcsv(:,3));

%maplonmin = minlon - 5;
maplonmin = max(minlon-5,-180);
maplonmax = maxlon + 5;
maplatmin = minlat - 5;
maplatmax = maxlat + 5;

% if minlon < -174
%     maplonmin = -180;
% end

if maxlon > 174
    maplonmax = 180;
end

if minlat > -85 && minlat < 0
    maplatmin = -90;
end

if maxlat > 85 && maxlat > 0
    maplatmax = 90;
end

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

rectangle('Position',[minlon minlat abs(abs(maxlon)-abs(minlon)) abs(abs(maxlat)-abs(minlat))])

