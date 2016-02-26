function catmaghist(eqevents)
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
Mn = min(eqevents(:,5))-0.05;
Mx = max(eqevents(:,5))+0.05;
step = 0.1;
bins = Mn:step:Mx;
%
% Figure
%
figure
hold on
histogram(eqevents(:,5),bins)
%
% Format Options
%
title('Earthquake Magnitude Histogram')
xlabel('Magnitude')
ylabel('Number of Events')
set(gca,'fontsize',15)
hold off
drawnow
%
% End of function
%
end