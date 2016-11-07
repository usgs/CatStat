function inteventspace(EQEvents,sizenum)
% This function plots and compares the time between events (inter-temporal event spacing). 
% Input: EQEvents -  data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type of earthquakes ONLY
%        sizenum - plotting format determined in basiccatsum
%
% Output: None
%
% Written by: Matthew R Perry
% Last Edit: 07 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get catalog length
%
M = size(EQEvents,1);
%
% Determine the amount of time between events in the catalog
%
timesep = diff(EQEvents.OriginTime,1)*1440;
datetimesep = horzcat(EQEvents.OriginTime(1:(M-1)),timesep(:,1));
%
% Sort the inter-event spacing and get the median and max separation times
%
sorttime = sortrows(timesep,1);
mediansep = median(sorttime(:,1));
maxsep = sorttime(M-1,1);
%
% Print out
%
disp(['The Median Time Between Earthquakes: ',num2str(mediansep),' minutes'])
disp(['The Maximum Time Between Earthquakes: ',num2str(maxsep),' minutes'])
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
title('Time Separation Between Earthquakes','fontsize',18)
datetick('x')
% if sizenum == 1
%     datetick('x','yyyy');
% elseif sizenum == 2
%     datetick('x','mmmyy');
% else
%     datetick('x','mm-dd-yy');
% end
axis tight
%
% Case specific subplots
%
hold off
if sizenum == 1
    %
    % Time Separation Year Specific Statistics
    %
    timedif = diff(EQEvents.OriginTime);
    dateV = datevec(EQEvents.OriginTime);
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
    title('Maximum Earthquake Separation by Year','fontsize',18)
    ylabel('Length of Time Separation (Minutes)','fontsize',18)
    xlabel('Year','fontsize',18);
%   set(gca,'XTick',min(years):2:max(years))
    set(gca,'XTickLabelRotation',45)
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
    title('Median Earthquake Separation by Year','fontsize',18)
    xlabel('Year','fontsize',18);
%   set(gca,'XTick',min(years):2:max(years))
    set(gca,'XTickLabelRotation',45)
    axis tight;
    hold off
elseif sizenum == 3
    %
    % Time Separation Daily Specific Statistics
    %
    timedif = diff(EQEvents.OriginTime);
    dateV = datevec(EQEvents.OriginTime);
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
    title('Maximum Earthquake Separation by Day')
    ylabel('Length of Time Separation (Minutes)')
    set(gca,'fontsize',15)
    set(gca,'XTickLabelRotation',45)
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
    set(gca,'XTickLabelRotation',45)
    title('Median Earthquake Separation by Day','fontsize',16)
    delete(findobj('marker','*'))
    axis tight
    hold off
else
    %
    % Time Separation Monthly Specific Statistics
    %
    timedif = diff(EQEvents.OriginTime);
    dateV = datevec(EQEvents.OriginTime);
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
    bar(monthlydatenum(1:end-1),maxsepmth,'hist')
    hold on
    %
    % Subplot 2 Format Options
    %
    datetick('x','mmmyy')
    set(gca,'fontsize',15)
    set(gca,'XTickLabelRotation',45)
    title('Maximum Earthquake Separation by Month')
    ylabel('Length of Time Separation (Minutes)')
    delete(findobj('marker','*'))
    axis tight
    hold off
    %
    % Subplot 3
    %
    subplot(3,1,3)
    hold on
    bar(monthlydatenum(1:end-1),medsepmth,'hist')
    %
    % Subplot 3 Format Options
    %
    datetick('x','mmmyy')
    set(gca,'fontsize',15)
    set(gca,'XTickLabelRotation',45)
    title('Median Earthquake Separation by Month')
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
