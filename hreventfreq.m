function hreventfreq(catalog)
% This function plots and compares event frequency throughout the hours in a day. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

disp(['Comparison of event activity to hours throughout the day may indicate ']);
disp(['the degree of anthropogenic influence - such as mining blasts - in the']);
disp(['catalog. Or increased human activity could reduce ability to register ']);
disp(['earthquake activity.']);
%disp(['Vertical lines indicate typical sunrise/sunset hours (daytime).']);
disp([' ']);

% find hour of the day in Pacific Standard Time (GMT -8)
hour = mod(catalog.data(:,1)*24-8,24);

figure
% [nn,xx] = hist(hour,0.5:23.5);
hist(hour,0.5:23.5);
xlabel('Hour of the Day (Pacific Standard Time UTC-8)','fontsize',18)
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

