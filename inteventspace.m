function inteventspace(catalog,sizenum)
% This function plots and compares the time between events (inter-temporal event spacing). 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

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
stem(datetimesep(:,1),datetimesep(:,2),'Marker','none')
%plot(datetimesep(:,1),datetimesep(:,2))
set(gca,'fontsize',15)
title('Time Separation Between Events','fontsize',18)
if sizenum == 1
    datetick('x','yyyy');
elseif sizenum == 2
    datetick('x','mmmyy');
else
    datetick('x','mm-dd-yy');
end
ax = axis;
axis([datetimesep(1,1) datetimesep(length(datetimesep),1) 0 max(datetimesep(:,2))*1.1])

if sizenum == 1

    % Time Separation Year Specific Statistics

    timedif = diff(catalog.data(:,1));
    dateV = datevec(catalog.data(:,1));
    years = dateV(:,1);
    years(1) = []; % make years same size as difference vector
    XX = min(years):max(years);

    for ii = 1:length(XX)
        if length(timedif(years == XX(ii))) > 0
            maxsepyr(ii) = max(timedif(years == XX(ii)));
            medsepyr(ii) = median(timedif(years == XX(ii)));
        end
    end

    subplot(3,1,2)
    bar(XX,maxsepyr,1)
    set(gca,'fontsize',15)
    title('Maximum Event Separation by Year','fontsize',18)
    ylabel('Length of Time Separation (Days)','fontsize',18)
    xlabel('Year','fontsize',18);
    set(gca,'XTick',min(years):2:max(years))
    axis tight;
    ax = axis;
    axis([ax(1:2), 0 ax(4)*1.1])
    subplot(3,1,3)
    bar(XX,medsepyr,1)
    set(gca,'fontsize',15)
    title('Median Event Separation by Year','fontsize',18)
    xlabel('Year','fontsize',18);
    set(gca,'XTick',min(years):2:max(years))
    axis tight;
    ax = axis;
    axis([ax(1:2), 0 ax(4)*1.1])

elseif sizenum == 3
    
    % Time Separation Daily Specific Statistics
    
    timedif = diff(catalog.data(:,1));
    dateV = datevec(catalog.data(:,1));
    
    daily = unique(dateV(:,1:3),'rows'); % finds unique month and year combinations
    [~,subs] = ismember(dateV(:,1:3),daily,'rows');
    L = length(subs)-1;
    maxsepday = accumarray(subs(1:L),timedif(:,1),[],@max);
    medsepday = accumarray(subs(1:L),timedif(:,1),[],@median);
    matones = ones(length(daily(:,1)),1);
    fakedayyear = horzcat(daily,matones);
    dailydatenum = datenum(fakedayyear(:,1:3));
    
    subplot(3,1,2)
    bar(dailydatenum(1:(length(dailydatenum)-1),:),maxsepday,'hist')
    datetick('x','mm-dd-yy')
    set(gca,'fontsize',15)
    title('Maximum Event Separation by Day','fontsize',16)
    ylabel('Length of Time Separation (Days)','fontsize',16)
    delete(findobj('marker','*'))
    ax = axis;
    axis([datetimesep(1,1) datetimesep(length(datetimesep),1) 0 max(maxsepday)*1.1])

    subplot(3,1,3)
    bar(dailydatenum(1:(length(dailydatenum)-1),:),medsepday,'hist')
    datetick('x','mm-dd-yy')
    set(gca,'fontsize',15)
    title('Median Event Separation by Day','fontsize',16)
    delete(findobj('marker','*'))
    ax = axis;
    axis([datetimesep(1,1) datetimesep(length(datetimesep),1) 0 max(medsepday)*1.1])
    
else
    
    % Time Separation Monthly Specific Statistics
    
    timedif = diff(catalog.data(:,1));
    dateV = datevec(catalog.data(:,1));

    monthly = unique(dateV(:,1:2),'rows'); % finds unique month and year combinations
    [~,subs] = ismember(dateV(:,1:2),monthly,'rows');
    L = length(subs)-1;
    maxsepmth = accumarray(subs(1:L),timedif(:,1),[],@max);
    medsepmth = accumarray(subs(1:L),timedif(:,1),[],@median);
    matones = ones(length(monthly(:,1)),1);
    fakemonthyear = horzcat(monthly,matones);
    monthlydatenum = datenum(fakemonthyear(:,:));
    
    subplot(3,1,2)
    bar(monthlydatenum,maxsepmth,'hist')
    %bar(monthlydatenum(1:(length(monthlydatenum)-1),:),maxsepmth,'hist')
    datetick('x','mmmyy')
    set(gca,'fontsize',15)
    title('Maximum Event Separation by Month','fontsize',16)
    ylabel('Length of Time Separation (Days)','fontsize',16)
    delete(findobj('marker','*'))
    ax = axis;
    axis([datetimesep(1,1) datetimesep(length(datetimesep),1) 0 max(maxsepmth)*1.1])

    subplot(3,1,3)
    bar(monthlydatenum,medsepmth,'hist')
    %bar(monthlydatenum(1:(length(monthlydatenum)-1),:),medsepmth,'hist')
    datetick('x','mmmyy')
    set(gca,'fontsize',15)
    title('Median Event Separation by Month','fontsize',16)
    delete(findobj('marker','*'))
    ax = axis;
    axis([datetimesep(1,1) datetimesep(length(datetimesep),1) 0 max(medsepmth)*1.1])
    
end
