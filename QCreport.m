%% Basic Catalog Summary
%
close all
% Load catalog data
catalog = loadcat(catalog);
% 
basiccatsum(catalog);
%
%Used to determine if plots should be made by year or month or day based on catalog size
%
[sizenum] = catalogsize(catalog); 
%
%% Seismicity Map
%
[eqevents] = plotcatmap(catalog); % If using a regional network, be sure to change the polygon being displayed (comment out all others)
%
%% Seismicity Density Plot
%
catdensplot(catalog);

%% Depth Distribution

plotcatdeps(eqevents);

%% Event Frequency

eventfreq(eqevents,sizenum);

%% Hourly Event Frequency

hreventfreq(eqevents,catalog); % Make sure to edit the change in timezone for regional networks in the init file

%% Inter-Event Temporal Spacing

inteventspace(catalog,sizenum);

%% Magnitude Distribution: All Magnitudes

[yrmageqcsv] = catmagdistrib(eqevents,sizenum);

%% Magnitude Distribution: All Magnitudes Histogram

catmaghist(eqevents)

%% Magnitude & Event Count

if sizenum == 1
    magspecs(yrmageqcsv);
end

%% Magnitude Distribution: Median Magnitudes
 
plotyrmedmag(eqevents,sizenum);

%% Magnitude Distribution: Overall Completeness

catmagcomp(yrmageqcsv,catalog.name);

% Magnitude Distribution: 5 Year Completeness

% if sizenum == 1
%    catmagyrcomp(yrmageqcsv,s);
% end

%% Magnitude Distribution: Completeness Through Time

if sizenum == 1
    catmagcomphist(eqevents,yrmageqcsv);
end

%% Event Type Frequency

evtypetest(catalog,sizenum)

%% Searching for Duplicate Events

catdupsearch(catalog);

%% Possible Duplicate Events

dups=catdupevents(catalog);

%% Largest Events

lrgcatevnts(catalog)

% Yearly Event Count List
% 
% dispyrcount(catalog,sizenum)

