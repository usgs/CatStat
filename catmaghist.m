function catmaghist(eqevents)
% This function plots and compares the magnitude completeness. 
% Input: A matrix of all the catalog.data for earthquake-type events only.
% Output: None
%
% Print out
%
disp(['Magnitude distribution of earthquake events only. All other event types ignored.']);
%
% Figure
%
figure
hold on
histogram(eqevents(:,5),min(eqevents(:,5)):0.1:max(eqevents(:,5)))
%
% Format Options
%
title('Earthquake Magnitude Histogram')
xlabel('Magnitude')
ylabel('Number of Events')
set(gca,'fontsize',15)
hold off
drawnow