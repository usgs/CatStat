function plottrimcats(cat1, cat2, reg)
%
% Function that plots the results from trimcats.m
%
% Inputs -
%   cat1 - Catalog 1 structure (from trimcats)
%   cat2 - Catalog 2 structure (fron trimcats)
%   reg - Region of interest (originally from initQCMulti.dat)
%
% Outputs - None 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
plotworld
%
% Plot Catalog 1 data
%
h1 = plot(cat1.data(:,3),cat1.data(:,2),'r.');
%
% Plot Catalog 2 data
%
h2 = plot(cat2.data(:,3),cat2.data(:,2),'b.');
%
% Plot region
%
plot(poly(:,1),poly(:,2),'k--','LineWidth',2)
%
% Get minimum and maximum values for restricted axes
%
minlon = min(poly(:,1))-0.5;
maxlon = max(poly(:,1))+0.5;
minlat = min(poly(:,2))-0.5;
maxlat = max(poly(:,2))+1.0;
%if strcmpi(reg,'all')
%    minlon = -
%
% Plot formatting
%
legend([h1 h2],[cat1.name,'--',num2str(size(cat1.data,1))],[cat2.name,'--',num2str(size(cat2.data,1))])
axis([minlon maxlon minlat maxlat])
midlat = (maxlat+minlat)/2;
set(gca,'DataAspectRatio',[1,cosd(midlat),1])
xlabel('Longitude','FontSize',14)
ylabel('Latitude','FontSize',15)
set(gca,'FontSize',15)
title(['Comparison of ',cat1.name,' and ',cat2.name],'FontSize',14)
box on
hold off
drawnow
%
% End of Function
%
end
