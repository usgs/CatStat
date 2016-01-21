function [cat1, cat2] = plottrimcats_mp(cat1, cat2, reg, ind1, ind2)
%
% Restrict to Region of interest
%
load('regions.mat')
ind = find(strcmp(region,reg));
poly = coord{ind,1};
%
% Initiate Figure
%
figure
hold on
%
% Function that plots the world map
%
plotworld_mp
%
% Plot Catalog 1 data
%
h1 = plot(cat1.data(ind1,3),cat1.data(ind1,2),'r.');
h2 = plot(cat1.data(~ind1,3),cat1.data(~ind1,2),'k.');
%
% Plot Catalog 2 data
%
h3 = plot(cat2.data(ind2,3),cat2.data(ind2,2),'b.');
h4 = plot(cat2.data(~ind2,3),cat2.data(~ind2,2),'k.');
plot(poly(:,1),poly(:,2),'Color',[1 1 1]*0.25,'LineWidth',2)
%legend([h1 h3],{cat1.name,cat2.name})
%legend([h2 h4],{'Outside Region', 'Outside Region'})
%
% Get minimum and maximum values for restricted axes
%
minlon = min(poly(:,1))-0.5;
maxlon = max(poly(:,1))+0.5;
minlat = min(poly(:,2))-0.5;
maxlat = max(poly(:,2))+0.5;
%
% Plot formatting
%
axis([minlon maxlon minlat maxlat])
midlat = (maxlat-minlat)/2;
set(gca,'DataAspectRatio',[1,cosd(midlat),1])
xlabel('Longitude','FontSize',14)
ylabel('Latitude','FontSize',15)
set(gca,'FontSize',15)
title(['Comparison of ',cat1.name,' and ',cat2.name],'FontSize',14)
%
% Save output
%
% Catalog 1
cat1.data = cat1.data(ind1,:);
cat1.id = cat1.id(ind1,:);
cat1.evtype = cat1.evtype(ind1,:);
%
% Catalog 2
%
cat2.data = cat2.data(ind2,:);
cat2.id = cat2.id(ind2,:);
cat2.evtype = cat2.evtype(ind2,:);