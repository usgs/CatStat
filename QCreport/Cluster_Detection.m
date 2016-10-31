% function for use in QC Report
function [] = Cluster_Detection(EQEvents, Mc)
%
% Script based off Zaliapin et al 2013 for Cluster Analysis using minimal
% spatio-temporal distances
%
% Mc of 2.5 or 3.0 will effectively show clustering.  Any smaller than 2.5
% and the algorithm become prohibitively time consuming.  This is highly
% dependent on the size of the catalog!!!  
%
% If the catalog is sufficiently large, alter the Mc for computational efficiency
%
if length(EQEvents.Mag) > 300000;
    Mc = 3.0;
end
ind = find(EQEvents.Mag >= Mc);
if ~isempty(ind)
    EQEvents = EQEvents(ind,:);
else
    EQEvents = EQEvents;
end
%
% ensure eqevents is sorts
%
EQEvents = sortrows(EQEvents,1);
%
% Set constants as per Zaliapin et al., 2013
%
b = 1; % Assumed B-value of declustered distribution
df = 1.6;
q = 0.5;
for ii = length(EQEvents.Mag):-1:2
    child  = EQEvents(ii,:); % Set child event
    parent = EQEvents(EQEvents.Mag >= child.Mag(1),:); % Set parent event
    t = (child.OriginTime(1) - parent.OriginTime)./365;
    % If t is >= 0, make inf
    t(t <= 0) = inf;
    % Get spatial distance
    r = distance_hvrsn(child.Latitude,child.Longitude,parent.Latitude,parent.Longitude);
    r(r == 0) = inf;
    n = t.*r.^(df).*10.^(-b.*parent.Mag); % eta from equation 1
    [~,ind] = min(n);
    % Get minimum and save values
    T(ii-1,1) = t(ind)*10^(-q*b*parent.Mag(ind));
    R(ii-1,1) = r(ind)^(df)*10^(-(1-q)*b*parent.Mag(ind));
    N(ii-1,1) = T(ii-1,1)*R(ii-1,1);%n(ind);
    NND(ii-1,:) = [ind,ii,t(ind),r(ind),n(ind),T(ii-1,1),R(ii-1,1),N(ii-1,1)];
end
figure;clf
plot(EQEvents.OriginTime(EQEvents.Mag>2.0),EQEvents.Latitude(EQEvents.Mag>2.0),'k.','MarkerSize',0.25)
datetick('x')
xlabel('Date','fontsize',14)
ylabel('Latitude','fontsize',14)
title('Event Latitude by Date: M>2.0 Plotted','fontsize',18)
set(gca,'fontsize',14)
set(gca,'XTickLabelRotation',45)
axis tight
 axis square
%
% NND Histogram
% Bimodal distribution indicates presence of clustering.  Theorectically, a
% declustered catalog will show only one mode.
%
figure;clf
histogram(log10(NND(:,5)),100,'normalization','pdf')
xlabel('Nearest-Neighbor Distance - log10(\eta)','fontsize',14)
ylabel('Density','fontsize',14)
title(sprintf('Nearest Neighbor Distance Histogram\nM>%1.2f',Mc),'fontsize',18)
set(gca,'fontsize',14)
axis square
axis tight
%
% End of Function
%
end
