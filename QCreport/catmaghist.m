function catmaghist(EQEvents, Mc)
% This function plots and compares the magnitude completeness. 
% Input: A matrix of all the catalog.data for earthquake-type events only.
% Output: None
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