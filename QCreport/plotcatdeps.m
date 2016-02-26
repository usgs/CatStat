function plotcatdeps(eqevents)
% This function plots the distribution of event depth 
% Input:  eqevents - Only earthquake events from the original catalog
%         
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
disp('Depth distribution of EARTHQUAKE EVENTS ONLY. All other event types ignored.');
%
% Replace any erroneous depths with NaN
%
eqevents(eqevents(:,4)==-999,4) = NaN;
%
% Get minimum and maximum depths
%
maxdep = max(eqevents(:,4));
mindep = min(eqevents(:,4));
%
% Determine the number of events with NaN as depths
%
nandepcount = sum(isnan(eqevents(:,4)));
%
% Print results
%
disp(['Minimum Depth: ',int2str(mindep)])
disp(['Maximum Depth: ',int2str(maxdep)])
disp(['Number of Events without a Depth: ',int2str(nandepcount)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Histogram of All Depths
%
figure
subplot(2,1,1)
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
% Histogram of depths within 2 sigma
%
subplot(2,1,2)
hold on
y=histogram(eqevents(:,4));
%
%
%
set(gca,'fontsize',15)
title('Depth Histogram within 2 sigma','fontsize',18)
xlabel('Depth [km]','fontsize',18)
ylabel('Number of Events','fontsize',18)
axis([0 median(eqevents(:,4))+2*std(eqevents(:,4)),0,max(y.Values)])
hold off
drawnow
%
%End of Function
%
end