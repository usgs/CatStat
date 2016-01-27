function plotcatdeps(eqevents)
% This function plots the distribution of event depth 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None
disp('Depth distribution of EARTHQUAKE EVENTS ONLY. All other event types ignored.');
eqevents(eqevents(:,4)==-999,4) = NaN;
maxdep = max(eqevents(:,4));
mindep = min(eqevents(:,4));
%
nandepcount = sum(isnan(eqevents(:,4)));
%
disp(['Minimum Depth: ',int2str(mindep)])
disp(['Maximum Depth: ',int2str(maxdep)])
disp(['Number of Events without a Depth: ',int2str(nandepcount)])
%
% Histogram of Depths
%
figure
hold on
histogram(eqevents(:,4))
%
% Format Options
%
set(gca,'fontsize',15)
title('Depth Histogram','fontsize',18)
xlabel('Depth [km]','fontsize',18)
ylabel('Number of Events','fontsize',18)
axis tight;
hold off
drawnow
%
%End of Function
%