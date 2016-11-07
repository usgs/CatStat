function catmaghist(EQEvents, Mc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function plots  histogram of the magnitudes in EQEvents
%
% Input: Necessary components described
%       EQEvents -  data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type of earthquakes ONLY
%       Mc - Estimated magnitude of completeness.
%
% Output: None
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Print out
%
disp(['Magnitude distribution of earthquake events only. All other event types ignored.']);
%
% Get bins
%
Mn = min(EQEvents.Mag)-0.05;
Mx = max(EQEvents.Mag)+0.05;
step = 0.1;
bins = Mn:step:Mx;
%
% Figure
%
figure
hold on
h = histogram(EQEvents.Mag,bins);
h1 = plot([Mc Mc],[min(h.Values), max(h.Values)],'r--');
%
% Format Options
%
title('Earthquake Magnitude Histogram')
xlabel('Magnitude')
ylabel('Number of Events')
legend([h1],'Mc')
set(gca,'fontsize',15)
hold off
drawnow
%
% End of function
%
end