function catdupsearch(catalog)
% This function plots and searches for possible duplicate events based on various time and distance parameters.
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

% Calculate Number of Events within XX seconds and XZ km
% This plot is to help pick thresholds to look for duplicate events. It
% shows the number of events within a given time and distance
% separation. It is an estimate because it just compares events adjacent in
% time. It does not compare each event to every other event in the catalog.


nquakes = size(catalog.data,1);
tdifsec = abs(diff(catalog.data.OriginTime))*24*60*60;
[ddelkm] = distance_hvrsn(catalog.data.Latitude(1:(nquakes-1)), ...
    catalog.data.Longitude(1:(nquakes-1)), ...
    catalog.data.Latitude(2:nquakes), catalog.data.Longitude(2:nquakes));
nn = []; xx = [];
kmLimits = [1,2,4,8,16,32,64,128];
tmax = 5;
dt = 0.05;

for jj = 1:length(kmLimits)
   [nn(jj,:),xx(jj,:)] = hist(tdifsec(ddelkm<kmLimits(jj) & tdifsec < (tmax+dt/2)),[dt/2:dt:(tmax-dt/2)]);
end

totMatch = cumsum(nn');
figure
plot(xx(1,:)+dt/2,totMatch)
hold on
title('Cumulative number of events withing X seconds and Z km (Z specified in legend)')
xlabel('Seconds')
ylabel('Total Number of Events')

legend(num2str(kmLimits'),'location','NorthWest')

