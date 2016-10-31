%% Basic Catalog Summary
%
% Load catalog data
catalog = loadcat(catalog);
% Trim the catalog if region is selected
if strcmpi(reg,'all');
    catalog = catalog;
else
    catalog = trimcatalog(catalog,reg);
end
% 
sizenum = basiccatsum(catalog);
%% Seismicity Map
%
[EQEvents, nonEQEvents] = plotcatmap(catalog,reg); % If using a regional network, be sure to change the polygon being displayed (comment out all others)
%
%% Seismicity Density Plot
%
% Earthquakes only considered in these density plots.
%
catdensplot(EQEvents,reg);
%% Median Magnitude Map
%
% Only Earthquakes are considered in this plot
%
catmedplot(EQEvents,25,reg)

%% Depth Distribution

plotcatdeps(EQEvents,reg,catalog.name);

%% Event Frequency

eventfreq(EQEvents,sizenum);

%% Hourly Event Frequency

hreventfreq(EQEvents,catalog);

%% Inter-Event Temporal Spacing -- 

inteventspace(EQEvents,sizenum);

%% Magnitude Distribution: Overall Completeness
[Mc] = catmagcomp(EQEvents,catalog.name,0.1,0.0);

%% Magnitude Distribution: All Magnitudes

catmagdistrib(EQEvents);

%% Magnitude Distribution: All Magnitudes Histogram

catmaghist(EQEvents,Mc)

%% Magnitude & Event Count

if sizenum == 1
    magspecs(EQEvents);
end

%% Magnitude Distribution: Median Magnitudes
plotyrmedmag(EQEvents,sizenum);

%% Magnitude Distribution: Completeness Through Time
if sizenum == 1
   catmagcomphist(EQEvents);
end
%% Cluster Identification
%
% Only Earthquakes are considered in this algorithm.  Bimodal distribution
% indicates clusters (i.e. foreshocks and aftershocks) are present in the
% data.  Unimodal distribution would indicate a declustered catalog.  This
% analysis is based off nearest-neighbor earthquake distances, which
% accounts for space, time, and magnitude distance of earthquakes (Zaliapin
% and Ben-Zion, 2013).
Cluster_Detection(EQEvents, Mc)

%% Cumulative Moment Release
CumulMomentRelease(EQEvents,catalog.name)

%% Largest Events

lrgcatevnts(catalog)

%% Event Type Frequency - last figure needs fixed

evtypetest(catalog,sizenum)

%% Searching for Duplicate Events

catdupsearch(catalog);

%% Possible Duplicate Events
maxSeconds = 2;
maxKm = 5;
magthres = -10;
dups=catdupevents(catalog,maxSeconds,maxKm,magthres);

% Yearly Event Count List
% 
% dispyrcount(catalog,sizenum)

