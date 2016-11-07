function [] = catmagdistrib(EQEvents)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function plots and compares the distribution of magnitude. 
%
% Input: EQEvents -  data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type of earthquakes ONLY
%
% Output: No Output
%
% Written by: Matthew R Perry
% Last Edit: 07 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Display
%
disp('Magnitude statistics and distribution of earthquake events throughout the catalog. All other event types ignored.')
%
% Convert -9.9 mags to NaN
%
EQEvents.Mag(EQEvents.Mag == -9.9) = NaN;
%
% Get data statistics
%
maxmag = max(EQEvents.Mag);
minmag = min(EQEvents.Mag);
zerocount = sum(EQEvents.Mag == 0);
nancount = sum(isnan(EQEvents.Mag));
%
% Remove NaN rows
%
ind = find(isnan(EQEvents.Mag));
if ~isempty(ind);
    EQEvents(ind,:) = [];
end
%
% Print Out
%
disp(['Minimum Magnitude: ',num2str(minmag)])
disp(['Maximum Magnitude: ',num2str(maxmag)])
disp([' ']);
disp(['Number of Events with Zero Magnitude: ',int2str(zerocount)])
disp(['Number of Events without a Magnitude: ',int2str(nancount)])
disp([' ']);
%
% Figure
%
figure
hold on
plot(datenum(EQEvents.OriginTime),EQEvents.Mag,'.');
%
% Format Options
%
datetick('x')
set(gca,'XTickLabelRotation',45)
set(gca,'fontsize',15)
title('All Magnitudes Through Catalog');
ylabel('Magnitude');
axis tight
hold off
drawnow
%
% End of Function
%
end