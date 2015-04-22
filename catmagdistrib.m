function [yrmagcsv] = catmagdistrib(catalog)
% This function plots and compares the distribution of magnitude. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

maxmag = max(catalog.data(:,5));
minmag = min(catalog.data(:,5));
zerocount = sum(catalog.data(:,5) == 0);
nancount = sum(isnan(catalog.data(:,5)) | catalog.data(:,5) == -9.9);

disp(['Minimum Magnitude: ',num2str(minmag)])
disp(['Maximum Magnitude: ',num2str(maxmag)])
disp([' ']);
disp(['Number of Events with Zero Magnitude: ',int2str(zerocount)])
disp(['Number of Events without a Magnitude: ',int2str(nancount)])
disp([' ']);

formatOut = 'yyyy';
time = datestr(catalog.data(:,1),formatOut);
time = str2num(time);
yrmagcsv = catalog.data;
yrmagcsv(:,1) = time(:,1); % Converts time column to only years

yrmagcsv(yrmagcsv(:,5)==-9.9,5) = NaN; %Converts all -9.9 preferred mags to NaN
% allmagcsv(allmagcsv(:,5)==0,5) = NaN; %Converts all 0 preferred mags to NaN
yrmagcsv(isnan(yrmagcsv(:,5)),:) = []; %Removes all rows with NaN for preferred mag

disp(['Plot of magnitudes over the span of the catalog - demonstrates gaps ']);
disp(['in the catalog that have 0 or NaN for the preferred magnitude.']);
disp([' ']);

figure
plot(datenum(catalog.data(:,1)),catalog.data(:,5),'.');
datetick
set(gca,'fontsize',15)
title('All Magnitudes Through Catalog','fontsize',18);
ylabel('Magnitude','fontsize',18);


