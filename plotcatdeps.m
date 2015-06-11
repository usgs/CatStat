function plotcatdeps(eqevents,catalog)
% This function plots the distribution of event depth 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

disp(['Depth distribution of earthquake events only. All other event types ignored.']);

maxdep = max(eqevents(:,4));
mindep = min(eqevents(:,4));
nandepcount = sum(isnan(eqevents(:,4)));

disp(['Minimum Depth: ',int2str(mindep)])
disp(['Maximum Depth: ',int2str(maxdep)])
disp(['Number of Events without a Depth: ',int2str(nandepcount)])

figure
eqevents(eqevents(:,4)==-999,4) = NaN;
%[nn,xx] = hist(catalog.data(:,4),ceil(mindep):1:maxdep);
hist(eqevents(:,4),(mindep+0.5):(maxdep-0.5))

axis tight;
ax = axis;
axis([mindep maxdep 0 ax(4)*1.1])
set(gca,'fontsize',15)
title('Depth Histogram','fontsize',18)
xlabel('Depth [km]','fontsize',18)
ylabel('Number of Events','fontsize',18)
