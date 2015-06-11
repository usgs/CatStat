function hreventfreq(eqevents,catalog)
% This function plots and compares event frequency throughout the hours in a day. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

disp(['Distribution of earthquake events throughout the hours of the day. All other event types ignored.']);

% find hour of the day in particular time zone
hour = mod(eqevents(:,1)*24-9,24);

figure
hist(hour,0.5:23.5);
%hist(eqevents(:,1),0.5:23.5);
xlabel('Hour of the Day (Hawaii Time Zone UTC-9)','fontsize',18)
ylabel('Number of Events','fontsize',18)
title('Events per Hour of the Day','fontsize',18)
set(gca,'linewidth',1.5)
set(gca,'fontsize',15)

axis tight;
ax = axis;
axis([ax(1:2),0,ax(4)*1.1])
%hhh=vline(7,'k');
%hhh=vline(14,'k');
hold off

