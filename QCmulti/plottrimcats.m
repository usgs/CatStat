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
% Restrict to Region of interest
% Get minimum and maximum values for restricted axes
%
load('regions.mat')
if strcmpi(reg,'all')
    poly(1,1) = min([cat1.data(:,3);cat2.data(:,3)]);
    poly(2,1) = max([cat1.data(:,3);cat2.data(:,3)]);
    poly(1,2) = min([cat1.data(:,2);cat2.data(:,2)]);
    poly(2,2) = max([cat1.data(:,2);cat2.data(:,2)]);
else
    ind = find(strcmp(region,reg));
    poly = coord{ind,1};
    %
    % Plot region
    %
    plot(poly(:,1),poly(:,2),'k--','LineWidth',2)
end
minlon = min(poly(:,1))-0.5;
maxlon = max(poly(:,1))+0.5;
minlat = min(poly(:,2))-0.5;
maxlat = max(poly(:,2))+1.0;
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
