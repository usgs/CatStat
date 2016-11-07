%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%QCReport.m --
%Script to run in order to generate single catalog QC report.  Please
%refer to documentation for explanation on functions/algorithms used
%within.
%
%
%This script is typically run under to 'publish' function through
%mkQCreport. Comments in the main script need cannot have a space after the percent symbol in
%order to remain unseen when report is published.  
%
%Comments inside subsequent functions are rendered normally and will not display on the
%report.  
%
%Mark-up is supported in the 'publish' function and any need to
%add or edit mark-up should follow the syntax discribed at 
%https://www.mathworks.com/help/matlab/matlab_prog/marking-up-matlab-comments-for-publishing.html
%
%Written By: Matthew R. Perry
%
%Last Edit: 04 November 2016
%For any issues, comments, or suggestions, please contact me through GitHub
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Basic Catalog Summary
%
%Load catalog data
catalog = loadcat(catalog);
%Trim the catalog if region is selected
if ~strcmpi(catalog.reg,'all') || ~strcmpi(catalog.auth,'none');
    catalog = trimcatalog(catalog);
end
%%
sizenum = basiccatsum(catalog);
%% Seismicity Map
%
[EQEvents, nonEQEvents] = plotcatmap(catalog);
%
%% Seismicity Density Plot
%
% Earthquakes only considered in these density plots.
%
catdensplot(EQEvents,catalog.reg);
%% Median Magnitude Map
%
% Only Earthquakes are considered in this plot. Computation of plot can be
% quite long if large, global catalogs are being considered.
%
catmedplot(EQEvents,25,catalog.reg)

%% Depth Distribution

plotcatdeps(EQEvents,catalog.reg);

%% Event Frequency

eventfreq(EQEvents,sizenum);

%% Hourly Event Frequency

hreventfreq(EQEvents,catalog.timeoffset,catalog.timezone);

%% Inter-Event Temporal Spacing -- 

inteventspace(EQEvents,sizenum);

%% Magnitude Distribution: Overall Completeness
[Mc] = catmagcomp(EQEvents,catalog.name,0.1);

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
%% Cumulative Moment Release
CumulMomentRelease(EQEvents,catalog.name)

%% Largest Events

lrgcatevnts(catalog)

%% Event Type Frequency

evtype(catalog,sizenum)

%% Searching for Duplicate Events

catdupsearch(catalog);

%% Possible Duplicate Events
maxSeconds = 2;
maxKm = 5;
magthres = -10;
dups=catdupevents(catalog,maxSeconds,maxKm,magthres);
%% Cluster Identification
%
% Only Earthquakes are considered in this algorithm.  Bimodal distribution
% indicates clusters (i.e. foreshocks and aftershocks) are present in the
% data.  Unimodal distribution would indicate a declustered catalog.  This
% analysis is based off nearest-neighbor earthquake distances, which
% accounts for space, time, and magnitude distance of earthquakes (Zaliapin
% and Ben-Zion, 2013).
%Cluster_Detection(EQEvents, Mc)