function plotcatdeps(sortcsv)
% This function plots the distribution of event depth 
% Input: Sorted catalog matrix
% Output: None

maxdep = max(sortcsv(:,4));
mindep = min(sortcsv(:,4));
nandepcount = sum(isnan(sortcsv(:,4)));

disp(['Minimum Depth: ',int2str(mindep)])
disp(['Maximum Depth: ',int2str(maxdep)])
disp(['Number of Events without a Depth: ',int2str(nandepcount)])

figure
sortcsv(sortcsv(:,4)==-999,4) = NaN;
%[nn,xx] = hist(sortcsv(:,4),ceil(mindep):1:maxdep);
hist(sortcsv(:,4),(mindep+0.5):(maxdep-0.5))

axis tight;
ax = axis;
axis([mindep maxdep 0 ax(4)*1.1])
set(gca,'fontsize',15)
title('Depth Histogram','fontsize',18)
xlabel('Depth [km]','fontsize',18)
ylabel('Number of Events','fontsize',18)