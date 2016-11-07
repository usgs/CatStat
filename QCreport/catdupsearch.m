function catdupsearch(catalog)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Number of Events within XX seconds and XZ km
% This plot is to help pick thresholds to look for duplicate events. It
% shows the number of events within a given time and distance
% separation. It is an estimate because it just compares events adjacent in
% time. It does not compare each event to every other event in the catalog.
%
% Input: Necessary components described
%        EQEvents -  data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type
% Output: None
%
% Written by: Matthew R Perry
% Last Edit: 07 November 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

