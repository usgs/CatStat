function catdensplot(catalog)
% This function creates a seismicity density map for the catalog
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
%         ** Hoping to add polygon for catalog as well
% Output: None

% subplot(1,2,1) % EQ Plot
% plot(catalog.data(:,3),catalog.data(:,2),'r.')
% daspect([1,1,1]);
% %set(gca,'fontsize',15)
% axis([minlon maxlon minlat maxlat]);
% hold on
% load ./Data/coastline.data
% coastline(coastline == 99999) = NaN;
% clat = coastline(:,2);
% clon = coastline(:,1);
% clon(abs(diff(clon))>180) = NaN;
% plot(clon,clat,'k','linewidth',1)
% xlabel('Longitude');
% ylabel('Latitude');
% hold on

%newcolormap = parula; % Makes the first value of the colormap white so that 0's are white, must turn off for large datasets!
%newcolormap(1,:) = [1 1 1];

%figure
%subplot(1,2,1) % Density Plot
figure('Color','w');  
axis equal;  
n = hist3(catalog.data(:,2:3),[50 50]); % creates a matrix of counts from hist3 binning
mask = ~logical(filter2(ones(3),n)); %http://stackoverflow.com/questions/17474817/hide-zero-values-counts-in-hist3-plot
n(mask) = NaN; % Converts all 0's to Nan
%n(size(n,1)+1,size(n,2)+1) = 0;
xb = linspace(min(catalog.data(:,3)),max(catalog.data(:,3)),size(n,1));
yb = linspace(min(catalog.data(:,2)),max(catalog.data(:,2)),size(n,1));
pcolor(xb,yb,n);
hchild=get(gca,'children'); %removes box outlines
set(hchild,'edgecolor','none') %removes box outlines
%colormap(newcolormap);
colormap(parula)
colorbar
hold on
load ./Data/coastline.data
coastline(coastline == 99999) = NaN;
clat = coastline(:,2);
clon = coastline(:,1);
clon(abs(diff(clon))>180) = NaN;
plot(clon,clat,'color',[0 0 0],'linewidth',2)
set(gca,'fontsize',15)
xlabel('Longitude','fontsize',18);
ylabel('Latitude','fontsize',18);
title('Density Plot','fontsize',18);

%subplot(1,2,2) % Log Density Plot
figure('Color','w');  
axis equal;  
n = hist3(catalog.data(:,2:3),[50 50]); % creates a matrix of counts from hist3 binning
n1 = log(n); % log0 = -Inf and log1 = 0
%n1(n1==-Inf) = 0; % changes -Inf to 0's but that means original both 1's and 0's are converted to white space
mask = ~logical(filter2(ones(3),n1)); %Smoothing? http://stackoverflow.com/questions/17474817/hide-zero-values-counts-in-hist3-plot
n1(mask) = NaN; % Converts all 0's to Nan
n1(n1==-Inf) = NaN; % changes -Inf to Nan
%n(size(n,1)+1,size(n,2)+1) = 0;
xb = linspace(min(catalog.data(:,3)),max(catalog.data(:,3)),size(n1,1));
yb = linspace(min(catalog.data(:,2)),max(catalog.data(:,2)),size(n1,1));
pcolor(xb,yb,n1);
hchild=get(gca,'children'); %removes box outlines
set(hchild,'edgecolor','none') %removes box outlines
%colormap(newcolormap);
colormap(parula)
colorbar
hold on
load ./Data/coastline.data
coastline(coastline == 99999) = NaN;
clat = coastline(:,2);
clon = coastline(:,1);
clon(abs(diff(clon))>180) = NaN;
plot(clon,clat,'color',[0 0 0],'linewidth',2)
set(gca,'fontsize',15)
xlabel('Longitude','fontsize',18);
ylabel('Latitude','fontsize',18);
title('Density Plot - Log Version','fontsize',18);

% figure %% 3D Version of Density Plot
% hist3(catalog.data(:,2:3),[50 50]);
% ax = gca;
% ax.YDir = 'reverse';
% h = get(gca,'child');
% heights = get(h,'Zdata');
% mask = ~logical(filter2(ones(3),heights));
% heights(mask) = NaN;
% set(h,'ZData',heights)
% set(gcf,'renderer','opengl');
% set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
% %colormap(flipud(summer))
% hold on
% load ./Data/coastline.data
% coastline(coastline == 99999) = NaN;
% clat = coastline(:,2);
% clon = coastline(:,1);
% clon(abs(diff(clon))>180) = NaN;
% plot(clon,clat,'color',[0.6 0.6 0.6],'linewidth',1)
% xlabel('Longitude');
% ylabel('Latitude');
% hold on
