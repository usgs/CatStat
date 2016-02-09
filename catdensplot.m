function catdensplot(catalog)
% This function creates a seismicity density map for the catalog
%
% Input: a structure containing catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
%         ** Hoping to add polygon for catalog as well
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
if minlon < -170 & maxlon > 170 & maxlat < 79 & minlat > -60
    maxlon = -1*min(abs(catalog.data(:,3)));
    minlon = -180;
end
%
% Density Plot and Log Density Plot
%
for ii = 1 : 2    
figure('Color','w')
hold on
n = hist2d(catalog.data(:,2),catalog.data(:,3),50)';
if ii == 2;
    n1 = log(n);
    mask = ~logical(filter2(ones(3),n1));
    n1(mask) = NaN;
    n1(n1==-Inf) = NaN;
    xb = linspace(min(catalog.data(:,3)),max(catalog.data(:,3)),size(n1,1));
    yb = linspace(min(catalog.data(:,2)),max(catalog.data(:,2)),size(n1,1));
    pcolor(xb,yb,n1);
    title('Log_{10} Density Plot')
else
    n(n == 0) = NaN;
    xb = linspace(min(catalog.data(:,3)),max(catalog.data(:,3)),size(n,1));
    yb = linspace(min(catalog.data(:,2)),max(catalog.data(:,2)),size(n,1));
    pcolor(xb,yb,n);
    title('Density Plot')
end
%
% Format Options
%
hchild=get(gca,'children'); %removes box outlines
set(hchild,'edgecolor','none') %removes box outlines
colormap(parula)
colorbar
set(gca,'fontsize',15)
xlabel('Longitude');
ylabel('Latitude');
set(gca,'DataAspectRatio',[1,cosd(midlat),1])
set(gca,'fontsize',15)
plotworld
axis([minlon maxlon minlat maxlat]);
box on
hold off
drawnow
end
%
% End of Function
%
end
