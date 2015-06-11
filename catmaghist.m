function catmaghist(eqevents)
% This function plots and compares the magnitude completeness. 
% Input: A matrix of all the catalog.data for earthquake-type events only.
% Output: None

disp(['Magnitude distribution of earthquake events only. All other event types ignored.']);

figure
hist(eqevents(:,5),[min(eqevents(:,5)):0.1:max(eqevents(:,5))])
title('Earthquake Magnitude Historgram','fontsize',18)
xlabel('Magnitude','fontsize',18)
ylabel('Number of Events','fontsize',18)
set(gca,'fontsize',15)