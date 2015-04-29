function inteventspace(catalog)
% This function plots and compares the time between events (inter-temporal event spacing). 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

disp(['The amount of time that passes between individual events can further']);
disp(['indicate how frequently events are occurring. Large time separations could']);
disp(['demonstrate gaps in the catalog. The median and maximum time separation ']);
disp(['for each year is also graphed to show the general trend in event frequency.']);
disp([' ']);

M = length(catalog.data);
timesep = [];

timesep = diff(catalog.data,1);
datetimesep = horzcat(catalog.data(1:(M-1),1),timesep(:,1));

sorttime = sortrows(timesep,1);
mediansep = median(sorttime(:,1));
maxsep = sorttime(M-1,1);

disp(['The Median Time Between Events: ',num2str(mediansep)])
disp(['The Maximum Time Between Events: ',num2str(maxsep)])

subplot(3,1,1)
plot(datetimesep(:,1),datetimesep(:,2))
%comb(datetimesep(:,1),datetimesep(:,2)) % Better for smaller data sets - do not use with large!
datetick
set(gca,'fontsize',15)
title('Time Separation Between Events','fontsize',18)
xlabel('Year','fontsize',18);
ax = axis;
axis([datetimesep(1,1) datetimesep(length(datetimesep),1) 0 max(datetimesep(:,2))*1.1])

% Time Separation Year Specific Statistics

timedif = diff(catalog.data(:,1));
dateV = datevec(catalog.data(:,1));
years = dateV(:,1);
years(1) = []; % make years same size as difference vector
XX = min(years):max(years);

for ii = 1:length(XX)
    maxsepyr(ii) = max(timedif(years == XX(ii)));
    medsepyr(ii) = median(timedif(years == XX(ii)));
end

subplot(3,1,2)
bar(XX,maxsepyr,1)
set(gca,'fontsize',15)
title('Maximum Event Separation by Year','fontsize',18)
ylabel('Length of Time Separation (Days)','fontsize',18)
xlabel('Year','fontsize',18);
axis tight;
ax = axis;
axis([ax(1:2), 0 ax(4)*1.1])

subplot(3,1,3)
bar(XX,medsepyr,1)
set(gca,'fontsize',15)
title('Median Event Separation by Year','fontsize',18)
xlabel('Year','fontsize',18);
axis tight;
ax = axis;
axis([ax(1:2), 0 ax(4)*1.1])

