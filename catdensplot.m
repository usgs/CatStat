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

%subplot(1,2,1) % Density Plot
figure('Color','w');   
n = hist2d(catalog.data(:,2),catalog.data(:,3),50)';
n(n == 0) = NaN; % Converts all 0's to Nan
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
plot(clon,clat,'color',[0 0 0],'linewidth',2)
daspect([1,1,1]);
set(gca,'fontsize',15)
xlabel('Longitude','fontsize',18);
ylabel('Latitude','fontsize',18);
title('Density Plot','fontsize',18);

%subplot(1,2,2) % Log Density Plot
figure('Color','w');   
n = hist2d(catalog.data(:,2),catalog.data(:,3),50)';
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
plot(clon,clat,'color',[0 0 0],'linewidth',2)
daspect([1,1,1]);
set(gca,'fontsize',15)
xlabel('Longitude','fontsize',18);
ylabel('Latitude','fontsize',18);
title('Density Plot - Log Version','fontsize',18);

else
    
%subplot(1,2,1) % Density Plot
figure('Color','w');  
axis equal;  
n = hist2d(catalog.data(:,2),catalog.data(:,3),50)';
n(n == 0) = NaN; % Converts all 0's to Nan
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

[tmppath,tmpname,tmpext] = fileparts(which('MkQCreport'));
tmpcmd = ['load ',tmppath,'/Data/coastline.data']; 
eval(tmpcmd)
clear tmppath tmpname tmpext tmpcmd

coastline(coastline == 99999) = NaN;
clat = coastline(:,2);
clon = coastline(:,1);
clon(abs(diff(clon))>180) = NaN;
plot(clon,clat,'color',[0 0 0],'linewidth',2)
daspect([1,1,1]);
set(gca,'fontsize',15)
xlabel('Longitude','fontsize',18);
ylabel('Latitude','fontsize',18);
title('Density Plot','fontsize',18);

%subplot(1,2,2) % Log Density Plot
figure('Color','w');  
axis equal;  
n = hist2d(catalog.data(:,2),catalog.data(:,3),50)';
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

[tmppath,tmpname,tmpext] = fileparts(which('QCreport'));
tmpcmd = ['load ',tmppath,'/Data/coastline.data']; 
eval(tmpcmd)
clear tmppath tmpname tmpext tmpcmd

coastline(coastline == 99999) = NaN;
clat = coastline(:,2);
clon = coastline(:,1);
clon(abs(diff(clon))>180) = NaN;
plot(clon,clat,'color',[0 0 0],'linewidth',2)
daspect([1,1,1]);
set(gca,'fontsize',15)
xlabel('Longitude','fontsize',18);
ylabel('Latitude','fontsize',18);
title('Density Plot - Log Version','fontsize',18);

end
