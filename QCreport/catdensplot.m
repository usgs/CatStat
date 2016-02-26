function catdensplot(catalog,reg)
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
if strcmpi(reg,'all')
    X = 0;
    poly(1,1) = min(catalog.data(:,3));
    poly(2,1) = max(catalog.data(:,3)); 
    poly(1,2) = min(catalog.data(:,2));
    poly(2,2) = max(catalog.data(:,2));
else
    X = 1;
    load('regions.mat')
    ind = find(strcmpi(region,reg));
    poly = coord{ind,1};
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
% Density Plot and Log Density Plot
%
for ii = 1 : 2    
figure('Color','w')
hold on
n = hist2d(catalog.data(:,2),catalog.data(:,3),100)';
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
if X == 1
    %
    % Plot region
    %
    plot(poly(:,1),poly(:,2),'k--','LineWidth',2)
end
axis([minlon maxlon minlat maxlat]);
box on
hold off
drawnow
end
%
% End of Function
%
end
