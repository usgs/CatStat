function hreventfreq(EQEvents,timeoffset,timezone)
% This function plots and compares event frequency throughout the hours in a day. 
% Input: EQEvents -  data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type of earthquakes ONLY
%        timeoffset - Time offset from UTC (e.g. EST UTC-5)
%        timezone - String describing time zone.
% Output: None
%
% Written by: Matthew R Perry
% Last Edit: 07 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Distribution of earthquake events throughout the hours of the day. All other event types ignored.']);
%
% Remove NaN
%
ind = find(isnan(EQEvents.Mag));
if ~isempty(ind);
    EQEvents(ind,:) = [];
end
%
% find hour of the day in particular time zone
%
hour = mod(EQEvents.OriginTime*24+timeoffset,24);
%
% Figure
%
figure
hold on
histogram(hour,0.5:23.5);
%
% Formatting Options
%
xlabel(['Hour of the Day (', timezone,')'],'fontsize',18)
ylabel('Number of Events','fontsize',18)
title('Events per Hour of the Day','fontsize',18)
set(gca,'fontsize',15)
axis tight;
hold off
%
% End of function
%
end

