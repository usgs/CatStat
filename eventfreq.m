function eventfreq(catalog)
% This function plots and compares event frequency over the entire catalog. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

disp(['The frequency of events within the catalog is analyzed by looking at the ']);
disp(['number of events per day (a) and the number of events throughout the day (b).']);
disp([' ']);
disp(['This first plot shows the number of events that occur throughout']);
disp(['the span of the catalog, providing a number count for each day.']);
disp([' ']);

figure
%[nn,xx]= hist(catalog.data(:,1),catalog.data(1,1):1:catalog.data(M,1));
hist(catalog.data(:,1),catalog.data(1,1)-0.5:1:max(catalog.data(:,1))-0.5)
datetick
set(gca,'fontsize',15)
title('Events per Day','fontsize',18)
ylabel('Number of Events','fontsize',18)
xlabel('Years','fontsize',18)
axis tight;
ax = axis;
axis([ax(1:2) 0 ax(4)*1.1])