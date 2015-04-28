function [s] = plotyrmedmag(catalog,yrmagcsv)
% This function plots and compares the trend of yearly median magnitude. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

M = length(yrmagcsv);
begyear = yrmagcsv(1,1);
endyear = yrmagcsv(M,1);
s = struct([]);
count = 1;

for jj = begyear:endyear % Create structure divided by year
    
    ii = find(yrmagcsv==jj);
    s(count).jj = yrmagcsv(ii,:);
    count = count + 1; 
    
end

count = 1;
newmedians = []; 

for yy = begyear:endyear % Create median file
    
    medrow = [yy,median(s(count).jj(:,5))];
    newmedians = [newmedians;medrow];
    count = count + 1;
    
end

disp(['Plot of the median magnitude (an approximate gauge for completeness)']);
disp(['through the time of the catalog.']);
disp([' ']);

figure
bar(newmedians(:,1),newmedians(:,2),'hist')
set(gca,'fontsize',15)
title('Yearly Median Magnitude','fontsize',18);
ylabel('Magnitude','fontsize',18);
xlabel('Year','fontsize',18);
axis([min(newmedians(:,1)) max(newmedians(:,1)) 0 max(newmedians(:,2))*1.1])

