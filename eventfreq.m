function eventfreq(sortcsv)
% This function plots and compares event frequency over the entire catalog and throughout the hours in a day. 
% Input: Sorted catalog matrix
% Output: None

disp(['The frequency of events within the catalog is analyzed by looking at the ']);
disp(['number of events per day (a) and the number of events throughout the day (b).']);
disp([' ']);
disp(['a. This first plot shows the number of events that occur throughout']);
disp(['the span of the catalog, providing a number count for each day.']);
disp([' ']);

figure
%[nn,xx]= hist(sortcsv(:,1),sortcsv(1,1):1:sortcsv(M,1));
hist(sortcsv(:,1),sortcsv(1,1)-0.5:1:max(sortcsv(:,1))-0.5)
datetick
set(gca,'fontsize',15)
title('Events per Day','fontsize',18)
ylabel('Number of Events','fontsize',18)
xlabel('Years','fontsize',18)
axis tight;
ax = axis;
axis([ax(1:2) 0 ax(4)*1.1])

% Event Frequency - Day vs. Night

disp(['b. Comparison of event activity to hours throughout the day may indicate ']);
disp(['the degree of anthropogenic influence - such as mining blasts - in the']);
disp(['catalog. Or increased human activity could reduce ability to register ']);
disp(['earthquake activity.']);
%disp(['Vertical lines indicate typical sunrise/sunset hours (daytime).']);
disp([' ']);

% find hour of the day in Pacific Standard Time (GMT -8)
hour = mod(sortcsv(:,1)*24-8,24);

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