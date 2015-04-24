function catdensplot(catalog,compmag)
% This function creates a seismicity density map for the catalog
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

% subplot(1,2,1)
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

%subplot(1,2,2)
figure('Color','w');  
axis equal;  
colormap(jet);
n = hist3(catalog.data(:,2:3),[50 50]);
mask = ~logical(filter2(ones(3),n));
n(mask) = NaN;
n(size(n,1)+1,size(n,2)+1) = 0;
xb = linspace(min(catalog.data(:,3)),max(catalog.data(:,3)),size(n,1));
yb = linspace(min(catalog.data(:,2)),max(catalog.data(:,2)),size(n,1));
pcolor(xb,yb,n);
hchild=get(gca,'children'); %removes box outlines
set(hchild,'edgecolor','none') %removes box outlines
colormap(parula)
hold on
load ./Data/coastline.data
coastline(coastline == 99999) = NaN;
clat = coastline(:,2);
clon = coastline(:,1);
clon(abs(diff(clon))>180) = NaN;
plot(clon,clat,'color',[0.6 0.6 0.6],'linewidth',1)
xlabel('Longitude');
ylabel('Latitude');

% figure %% 3D Version!
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
