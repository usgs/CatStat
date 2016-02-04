function plottimeseries(cat1, cat2, matching, missing)
% This function plots a time series of events in both catalogs, as well as
% those missing and matching from each catalog
%
% Input:
%   cat1: Catalog 1 data structure
%   cat2: Catalog 2 data structure
%   matching: Data structure of the matching events in each catalog
%   misssing: Data structure of the missing events from each catalog/
%
% Output:
%   None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Position',[100, 100, 1000, 500]);
hold on
%
% Plots
%
plot(cat2.data(:,1),-1.*ones(size(cat2.data,1),1),'b.','MarkerSize',15)
if ~isempty(missing.events2)
    plot(missing.events2(:,1),-0.5.*ones(size(missing.events2,1),1),'bx','MarkerSize',15)
end
if ~isempty(matching.data)
    plot(matching.data(:,1),zeros(size(matching.data,1),1),'k.','MarkerSize',15)
end
if ~isempty(missing.events1)
    plot(missing.events1(:,1),0.5.*ones(size(missing.events1,1),1),'rx','MarkerSize',15)
end
plot(cat1.data(:,1),ones(size(cat1.data,1),1),'r.','MarkerSize',15)
%
% Plot Formatting
%
datetick('x','yyyy-mm-dd')
ytick = [-1:0.5:1];
ylabs = [{cat2.name};{'Missing'};{'Matching'};{'Missing'};{cat1.name}];
ylim([-1.25 1.25])
set(gca,'YTick',ytick)
set(gca,'YTickLabel',ylabs)
box on
title('Time Series of Missing and Matching Events')
xlabel('Date')
set(gca,'FontSize',15)
hold off
drawnow
%
% End of Function
%
end