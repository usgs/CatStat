function plotyrmedmag(EQEvents,sizenum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function plots yearly median magnitude. 
%
% Input: Necessary components described
%       EQEvents -  data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type of earthquakes ONLY
%   sizenum - plot formatting option from basiccatsum
%
% Output: None
%
% Written by: Matthew R Perry
% Last Edit: 07 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
disp(['Median magnitude distribution of earthquake events only. All other event types ignored.']);
%
%Converts all -9.9 preferred mags to NaN and removes them
%
EQEvents.Mag(EQEvents.Mag==-9.9,:) = NaN; %
ind = find(isnan(EQEvents.Mag));
if ~isempty(ind)
    EQEvents(ind,:) = [];
end
%
% Plot results
%
if sizenum == 1
    %
    % Find year range
    %
    years = datestr(EQEvents.OriginTime,'yyyy');
    years = str2num(years);
    Years = table(years);
    EQEvents = [Years,EQEvents];
    year = unique(years);
    begyear = years(1,1);
    endyear = years(end,1);
    %
    % Get medians
    %
    med = zeros(length(year),2);
    for ii = 1 : length(year)
        med(ii,:) = [year(ii), median(EQEvents.Mag(year(ii) == EQEvents.years))];
    end
    %
    % Plot Results
    %
    figure
    hold on
    bar(med(:,1),med(:,2),'hist')
    %
    % Plot formatting
    %
    set(gca,'fontsize',15)
    title('Yearly Median Magnitude');
    delete(findobj('marker','*'))
    ylabel('Magnitude');
    xlabel('Year');
    axis tight
    hold off
    drawnow
elseif sizenum == 3
    %
    % Find Days (unique year, month, and day combinations)
    %
    dateV = datevec(EQEvents.OriginTime);
    daily = unique(dateV(:,1:3),'rows');
    [~,subs] = ismember(dateV(:,1:3),daily,'rows');
    %
    % Calculate median for each day
    %
    medmagday = accumarray(subs,EQEvents.Mag,[],@median);
    %
    % Create first day of every month matrix and convert (might not be
    % necessary) Used for plotting
    %
    matones = ones(length(daily(:,1)),1);
    fakedayyear = horzcat(daily,matones);
    dailydatenum = datenum(fakedayyear(:,1:3));
    %
    % Plot Results
    %
    figure
    hold on
    bar(dailydatenum,medmagday,'hist')
    %
    % Format Options
    %
    datetick('x','mm-dd-yy')
    set(gca,'fontsize',15)
    title('Daily Median Magnitude');
    ylabel('Magnitude');
    delete(findobj('marker','*'))
    axis tight
    hold off
    drawnow
else
    %
    % Find unique year and month combinations
    %
    dateV = datevec(EQEvents.OriginTime);
    monthly = unique(dateV(:,1:2),'rows');
    [~,subs] = ismember(dateV(:,1:2),monthly,'rows');
    %
    % Calculate monthly median
    %
    medmagmth = accumarray(subs,EQEvents.Mag,[],@median);
    %
    % Create a vector for plotting
    %
    matones = ones(length(monthly(:,1)),1); 
    fakemonthyear = horzcat(monthly,matones);
    monthlydatenum = datenum(fakemonthyear(:,:));
    %
    % Plot Results
    %
    figure
    hold on
    bar(monthlydatenum,medmagmth,'hist')
    %
    % Format Options
    %
    datetick('x','mmmyy')
    set(gca,'fontsize',15)
    title('Monthly Median Magnitude');
    ylabel('Magnitude');
    delete(findobj('marker','*'))
    axis tight
    hold off
    drawnow
end
%
% End of Function
%
end