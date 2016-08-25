%% Basic Catalog Summary
%
close all
% Load catalog data
catalog = loadcat(catalog);
% Trim the catalog if region is selected
if strcmpi(reg,'all');
    catalog = catalog;
else
    catalog = trimcatalog(catalog,reg);
end
% 
basiccatsum(catalog);
%
%Used to determine if plots should be made by year or month or day based on catalog size
%
[sizenum] = catalogsize(catalog); 
%
%% Seismicity Map
%
[eqevents,eqevents_ids] = plotcatmap(catalog,reg); % If using a regional network, be sure to change the polygon being displayed (comment out all others)
%
%% Seismicity Density Plot
%
% All event types are considered in these density plots.
%
catdensplot(catalog,reg);
%% Median Magnitude Map
%
% Only Earthquakes are considered in this plot
%
catmedplot(eqevents,25,1,reg)

%% Depth Distribution

plotcatdeps(eqevents,reg);

%% Event Frequency

eventfreq(eqevents,sizenum);

%% Hourly Event Frequency

hreventfreq(eqevents,catalog);

%% Inter-Event Temporal Spacing -- 

inteventspace(catalog,sizenum);

%% Magnitude Distribution: Overall Completeness
[Mc] = catmagcomp(catalog,0.1,0.0);

%% Magnitude Distribution: All Magnitudes

[yrmageqcsv] = catmagdistrib(eqevents,sizenum);

%% Magnitude Distribution: All Magnitudes Histogram

catmaghist(eqevents,Mc)

%% Magnitude & Event Count

if sizenum == 1
    magspecs(yrmageqcsv);
end

%% Magnitude Distribution: Median Magnitudes
plotyrmedmag(eqevents,sizenum);

%% Magnitude Distribution: Completeness Through Time

if sizenum == 1
   catmagcomphist(eqevents,yrmageqcsv);
%    catstatsthroughtime(eqevents);
end
%% Cluster Identification
%
% Only Earthquakes are considered in this algorithm.  Bimodal distribution
% indicates clusters (i.e. foreshocks and aftershocks) are present in the
% data.  Unimodal distribution would indicate a declustered catalog.  This
% analysis is based off nearest-neighbor earthquake distances, which
% accounts for space, time, and magnitude distance of earthquakes (Zaliapin
% and Ben-Zion, 2013).
Cluster_Detection(eqevents, Mc)

%% Cumulative Moment Release
CumulMomentRelease(eqevents,catalog.name,1)

%% Event Type Frequency

evtypetest(catalog,sizenum)

%% Largest Events

lrgcatevnts(catalog)

%% Searching for Duplicate Events

catdupsearch(catalog);

%% Possible Duplicate Events
maxSeconds = 2;
maxKm = 2;
magthres = -10;
dups=catdupevents(catalog,maxSeconds,maxKm,magthres);

% Yearly Event Count List
% 
% dispyrcount(catalog,sizenum)

