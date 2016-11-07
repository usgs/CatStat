function eventfreq(EQEvents,sizenum)
% This function plots and compares event frequency over the entire catalog. 
% Input: 
%       EQEvents -  data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type of earthquakes ONLY
%       sizenum - plotting option determined in basiccatsum
%
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
disp(['Frequency of EARTHQUAKE EVENTS ONLY. All other event types ignored.']);
%
% Remove NaN Earthquake Mags
%
ind = find(isnan(EQEvents.Mag));
if ~isempty(ind);
    EQEvents(ind,:) = [];
end
%
% Initialize Figure
%
figure
hold on
BINS = EQEvents.OriginTime(1)-0.5:1:max(EQEvents.OriginTime)-0.5;
histogram(EQEvents.OriginTime,BINS)
%
% Format Options
% 
set(gca,'fontsize',15)
title(sprintf('Events per Day\nNaN Mags removed'),'fontsize',18)
ylabel('Number of Events','fontsize',18)
if sizenum == 1
    datetick
    xlabel('Years','fontsize',18)
elseif sizenum == 2
    datetick('x','mmmyy')
    xlabel('Month-Year','fontsize',18)
else
    datetick('x','mm-dd-yy')
    xlabel('Month-Day-Year','fontsize',18)
end
axis tight;
hold off
drawnow
%
% End of Function
%
end