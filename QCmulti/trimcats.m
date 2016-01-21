function [cat1, cat2] = trimcats(cat1, cat2, reg, maglim, tmax,delmax,magdelmax,depdelmax)
%
% Function that will trim the catalogs to meet the criteria from the input
% file.  These criteria include:
%
% Inputs -
%   cat1 - Catalog 1 structure (from loadmulticat)
%   cat2 - Catalog 2 structure (fron loadmulticat)
%   reg - Region of interest (originally from initQCMulti.dat)
%   maglim - Minimum magnitude to be considered (originally from
%   initQCMulti.dat)
%   tmax - Maximum time window for matching events (originally from
%   initQCMulti.dat) -- Used for display purposes only
%   delmax - Maximum location difference for matching events (originally from
%   initQCMulti.dat) -- Used for display purposes only
%   magdelmax - Maximum magnitude difference for matching events
%   (originally from initQCMulti.dat) -- Used for display purposes only
%   depdelmac - Maximum depth difference for matching events (originally
%   from initQCMulti.dat) -- Used for display purposes only
%
% Outputs - 
%   cat1 - First catalog entries that fell within criteria
%   cat2 - First catalog entries that fell within criteria
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Begin function
%
%Trim catalogs to be the same time period
%
T = tmax;
tmax = tmax/24/60/60;
startdate = max(cat2.data(1,1),cat1.data(1,1))-tmax;
enddate = min(cat2.data(length(cat2.data),1),cat1.data(length(cat1.data),1))+tmax;
%
%Trim catalog 1 for overlapping time
%
time_ind1 = find(cat1.data(:,1) >= startdate & cat1.data(:,1) < enddate);
cat1.data = cat1.data(time_ind1,:);
cat1.id = cat1.id(time_ind1,:);
cat1.evtype = cat1.evtype(time_ind1,:);
%
%Trim catalog 2 for overlapping time
%
time_ind2 = find(cat2.data(:,1) >= startdate & cat2.data(:,1) < enddate);
cat2.data = cat2.data(time_ind2,:);
cat2.id = cat2.id(time_ind2,:);
cat2.evtype = cat2.evtype(time_ind2,:);
%
%Eliminate Magitudes below threshold
%
%Catalog 1
mag_ind1 = find(cat1.data(:,5) >= maglim);
cat1.data = cat1.data(mag_ind1,:);
cat1.id = cat1.id(mag_ind1,:);
cat1.evtype = cat1.evtype(mag_ind1,:);
%
%Catalog 2
%
mag_ind2 = find(cat2.data(:,5) >= maglim);
cat2.data = cat2.data(mag_ind2,:);
cat2.id = cat2.id(mag_ind2,:);
cat2.evtype = cat2.evtype(mag_ind2,:);
%
%Restrict catalog to region of interest
%
load('regions.mat')
ind = find(strcmp(region,reg));
poly = coord{ind,1};
%
%Catalog 1
%
ind1 = inpolygon(cat1.data(:,3),cat1.data(:,2),poly(:,1),poly(:,2));
%
%Catalog 2
%
ind2 = inpolygon(cat2.data(:,3),cat2.data(:,2),poly(:,1),poly(:,2));
%
%Print out
%
disp(' ')
disp(['Overlapping time period: ',datestr(startdate),' to ',datestr(enddate)])
disp(' ')
disp('------- Thresholds ------ ')
disp(' ')
disp(['Region: ',reg])
disp(['Time window: ',num2str(T),' s'])
disp(['Distance window: ',num2str(delmax),' km'])
disp(['Magnitude tolerance ',num2str(magdelmax)])
disp(['Depth tolerance ',num2str(depdelmax),' km'])
disp(' ')
%
%Initiate Figure
%
figure
hold on
%
%Function that plots the world map
%
plotworld
%
%Plot Catalog 1 data
%
h1 = plot(cat1.data(ind1,3),cat1.data(ind1,2),'r.');
h2 = plot(cat1.data(~ind1,3),cat1.data(~ind1,2),'r.');
%
%Plot Catalog 2 data
%
h3 = plot(cat2.data(ind2,3),cat2.data(ind2,2),'b.');
h4 = plot(cat2.data(~ind2,3),cat2.data(~ind2,2),'b.');
%
% Plot region
%
plot(poly(:,1),poly(:,2),'k--','LineWidth',2)
%
%Get minimum and maximum values for restricted axes
%
minlon = min(poly(:,1))-0.5;
maxlon = max(poly(:,1))+0.5;
minlat = min(poly(:,2))-0.5;
maxlat = max(poly(:,2))+0.5;
%
%Plot formatting
%
legend([h1 h3],{cat1.name,cat2.name})
axis([minlon maxlon minlat maxlat])
midlat = (maxlat-minlat)/2;
set(gca,'DataAspectRatio',[1,cosd(midlat),1])
xlabel('Longitude','FontSize',14)
ylabel('Latitude','FontSize',15)
set(gca,'FontSize',15)
title(['Comparison of ',cat1.name,' and ',cat2.name],'FontSize',14)
box on
hold off
drawnow
%
%Save output
%
%Catalog 1
cat1.data = cat1.data(ind1,:);
cat1.id = cat1.id(ind1,:);
cat1.evtype = cat1.evtype(ind1,:);
%
%Catalog 2
%
cat2.data = cat2.data(ind2,:);
cat2.id = cat2.id(ind2,:);
cat2.evtype = cat2.evtype(ind2,:);
%
%End of function
%
end
