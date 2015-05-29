function eventfreq(catalog,sizenum)
% This function plots and compares event frequency over the entire catalog. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

figure
%[nn,xx]= hist(catalog.data(:,1),catalog.data(1,1):1:catalog.data(M,1));
hist(catalog.data(:,1),catalog.data(1,1)-0.5:1:max(catalog.data(:,1))-0.5)
set(gca,'fontsize',15)
title('Events per Day','fontsize',18)
ylabel('Number of Events','fontsize',18)
if sizenum == 1
    datetick
    xlabel('Years','fontsize',18)
elseif sizenum == 2
    datetick('x','mmmyy')
    ylabel('Month-Year','fontsize',18)
else
    datetick('x','mm-dd-yy')
    ylabel('Month-Day-Year','fontsize',18)
end
axis tight;
ax = axis;
axis([ax(1:2) 0 ax(4)*1.1])