function inteventspace(catalog,sizenum)
% This function plots and compares the time between events (inter-temporal event spacing). 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
%    
%        Sizenum - plotting format determined by catalogsize
%
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get catalog length
%
M = length(catalog.data);
%
% Determine the amount of time between events in the catalog
%
timesep = diff(catalog.data,1);
datetimesep = horzcat(catalog.data(1:(M-1),1),timesep(:,1));
%
% Sort the inter-event spacing and get the median and max separation times
%
sorttime = sortrows(timesep,1);
mediansep = median(sorttime(:,1));
maxsep = sorttime(M-1,1);
%
% Print out
%
disp(['The Median Time Between Events: ',num2str(mediansep),' s.'])
disp(['The Maximum Time Between Events: ',num2str(maxsep),' s.'])
%
% Initialize Figure
%
figure
hold on
%
% Subplot 1
%
subplot(3,1,1)
hold on
stem(datetimesep(:,1),datetimesep(:,2),'Marker','none')
%
% Subplot 1 Format Options
%
set(gca,'fontsize',15)
title('Time Separation Between Events','fontsize',18)
if sizenum == 1
    datetick('x','yyyy');
elseif sizenum == 2
    datetick('x','mmmyy');
else
    datetick('x','mm-dd-yy');
end
axis tight
%
% Case specific subplots
%
hold off
if sizenum == 1
    %
    % Time Separation Year Specific Statistics
    %
    timedif = diff(catalog.data(:,1));
    dateV = datevec(catalog.data(:,1));
    years = dateV(:,1);
    years(1) = []; % make years same size as difference vector
    XX = min(years):max(years);
    %
    %
    %
    for ii = 1:length(XX)
        if length(timedif(years == XX(ii))) > 0
            maxsepyr(ii) = max(timedif(years == XX(ii)));
            medsepyr(ii) = median(timedif(years == XX(ii)));
        end
    end
    %
    % Subplot 2
    %
    subplot(3,1,2)
    hold on
    bar(XX,maxsepyr,1)
    %
    % Subplot 2 Format Options
    %
    set(gca,'fontsize',15)
    title('Maximum Event Separation by Year','fontsize',18)
    ylabel('Length of Time Separation (Days)','fontsize',18)
    xlabel('Year','fontsize',18);
    %set(gca,'XTick',min(years):2:max(years))
    axis tight;
    hold off
    %
    % Subplot 3
    %
    subplot(3,1,3)
    hold on
    bar(XX,medsepyr,1)
    %
    % Subplot 3 Format Options
    %
    set(gca,'fontsize',15)
    title('Median Event Separation by Year','fontsize',18)
    xlabel('Year','fontsize',18);
    %set(gca,'XTick',min(years):2:max(years))
    axis tight;
    hold off
elseif sizenum == 3
    %
    % Time Separation Daily Specific Statistics
    %
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
    %
    % Subplot 2
    %
    subplot(3,1,2)
    hold on
    bar(dailydatenum(1:end-1,1),maxsepday,'hist')
    %
    % Subplot 2 Format Options
    %
    datetick('x','mm-dd-yy')
    title('Maximum Event Separation by Day')
    ylabel('Length of Time Separation (Days)')
    set(gca,'fontsize',15)
    delete(findobj('marker','*'))
    axis tight
    hold off
    %
    % Subplot 3
    %
    subplot(3,1,3)
    hold on
    bar(dailydatenum(1:end-1,1),medsepday,'hist')
    %
    % Subplot 3 Format Options
    %
    datetick('x','mm-dd-yy')
    set(gca,'fontsize',15)
    title('Median Event Separation by Day','fontsize',16)
    delete(findobj('marker','*'))
    axis tight
    hold off
else
    %
    % Time Separation Monthly Specific Statistics
    %
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
    %
    % Subplot 2
    %
    subplot(3,1,2)
    bar(monthlydatenum,maxsepmth,'hist')
    hold on
    %
    % Subplot 2 Format Options
    %
    datetick('x','mmmyy')
    set(gca,'fontsize',15)
    title('Maximum Event Separation by Month')
    ylabel('Length of Time Separation (Days)')
    delete(findobj('marker','*'))
    axis tight
    hold off
    %
    % Subplot 3
    %
    subplot(3,1,3)
    hold on
    bar(monthlydatenum,medsepmth,'hist')
    %
    % Subplot 3 Format Options
    %
    datetick('x','mmmyy')
    set(gca,'fontsize',15)
    title('Median Event Separation by Month')
    delete(findobj('marker','*'))
    axis tight
    hold off
end
%
hold off
drawnow
%
% End of Function
%
end
