function catdupsearch(sortcsv)
% This function plots and searches for possible duplicate events based on various time and distance parameters.
% Input: Sorted catalog matrix
% Output: None

% Calculate Number of Events within X seconds and Z km
% This plot is to help pick thresholds to look for duplicate events. It
% shows the number of events within a given time and distance
% separation. It is an estimate because it just compares events adjacent in
% time. It does not compare each event to every other event in the catalog.

nquakes = length(sortcsv);
tdifsec = abs(diff(sortcsv(:,1)))*24*60*60;
ddelkm = distance(sortcsv(1:(nquakes-1),2:3),sortcsv(2:nquakes,2:3))*111.12;

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
%plot(xx(1,:)+0.5,totMatch,'o')
title('Cumulative number of events withing X seconds and Z km (Z specified in legend)')
xlabel('Seconds')
ylabel('Total Number of Events')

legend(num2str(kmLimits'),'location','NorthWest')

