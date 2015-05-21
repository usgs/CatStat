function [s] = plotyrmedmag(catalog,yrmagcsv,size)
% This function plots and compares the trend of yearly median magnitude. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

catalog.data(catalog.data(:,5)==-9.9,5) = NaN; %Converts all -9.9 preferred mags to NaN - so that it will match yrmagcsv
catalog.data(isnan(catalog.data(:,5)),:) = []; %Removes all rows with NaN for preferred mag

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

if length(size) > 3
    
    figure
    bar(newmedians(:,1),newmedians(:,2),'hist')
    set(gca,'fontsize',15)
    title('Yearly Median Magnitude','fontsize',18);
    ylabel('Magnitude','fontsize',18);
    xlabel('Year','fontsize',18);
    axis([min(newmedians(:,1)) max(newmedians(:,1)) 0 max(newmedians(:,2))*1.1])

elseif length(size) == 1
    
    dateV = datevec(catalog.data(:,1));
    daily = unique(dateV(:,1:3),'rows'); % finds unique month and year combinations
    [~,subs] = ismember(dateV(:,1:3),daily,'rows');
    L = length(subs);
    medmagday = accumarray(subs,catalog.data(:,1),[],@median);
    matones = ones(length(daily(:,1)),1);
    fakedayyear = horzcat(daily,matones);
    dailydatenum = datenum(fakedayyear(:,1:3));
    
    timedif = diff(catalog.data(:,1));
    dateV = datevec(catalog.data(:,1));
    
    daily = unique(dateV(:,1:3),'rows'); % finds unique month and year combinations
    [~,subs] = ismember(dateV(:,1:3),daily,'rows');
    medmagday = accumarray(subs,catalog.data(:,5),[],@median);
    
    figure
    %bar(newmedians(:,1),newmedians(:,2))
    bar(dailydatenum,medmagday,'hist')
    datetick('x','mm-dd-yy')
    set(gca,'fontsize',15)
    title('Daily Median Magnitude','fontsize',18);
    ylabel('Magnitude','fontsize',18);
    delete(findobj('marker','*'))
    ax = axis;
    axis([catalog.data(1,1) catalog.data(length(catalog.data(:,1)),1) 0 max(medmagday)*1.1])
    
else
    
    dateV = datevec(catalog.data(:,1));
    monthly = unique(dateV(:,1:2),'rows'); % finds unique month and year combinations
    [~,subs] = ismember(dateV(:,1:2),monthly,'rows');
    L = length(subs);
    medmagmth = accumarray(subs,catalog.data(:,1),[],@median);
    matones = ones(length(monthly(:,1)),1);
    fakemonthyear = horzcat(monthly,matones);
    monthlydatenum = datenum(fakemonthyear(:,:));
    
    timedif = diff(catalog.data(:,1));
    dateV = datevec(catalog.data(:,1));
    
    monthly = unique(dateV(:,1:2),'rows'); % finds unique month and year combinations
    [~,subs] = ismember(dateV(:,1:2),monthly,'rows');
    medmagmth = accumarray(subs,catalog.data(:,5),[],@median);

    figure
    %bar(newmedians(:,1),newmedians(:,2))
    bar(monthlydatenum,medmagmth,'hist')
    datetick('x','mmmyy')
    set(gca,'fontsize',15)
    title('Monthly Median Magnitude','fontsize',18);
    ylabel('Magnitude','fontsize',18);
    delete(findobj('marker','*'))
    ax = axis;
    axis([catalog.data(1,1) catalog.data(length(catalog.data(:,1)),1) 0 max(medmagmth)*1.1])

end

