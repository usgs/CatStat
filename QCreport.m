%% Basic Catalog Summary

close all



% Load catalog data
catalog = loadcat(catalog);

basiccatsum(catalog);

[sizenum] = catalogsize(catalog); % Used to determine if plots should be made by year or month or day based on catalog size

%% Seismicity Map

[eqevents] = plotcatmap(catalog); % If using a regional network, be sure to change the polygon being displayed (comment out all others)

%% Seismicity Density Plot

catdensplot(catalog);

%% Depth Distribution

plotcatdeps(eqevents,catalog);

%% Event Frequency

eventfreq(eqevents,catalog,sizenum);

%% Hourly Event Frequency

hreventfreq(eqevents,catalog); % Make sure to edit the change in timezone for regional networks in the init file

%% Inter-Event Temporal Spacing

inteventspace(catalog,sizenum);

%% Magnitude Distribution: All Magnitudes

[yrmageqcsv] = catmagdistrib(eqevents,catalog,sizenum);

%% Magnitude Distribution: All Magnitudes Histogram

catmaghist(eqevents)

%% Magnitude & Event Count

if sizenum == 1
    magspecs(yrmageqcsv,eqevents,catalog,sizenum);
end

%% Magnitude Distribution: Median Magnitudes

[s] = plotyrmedmag(eqevents,catalog,yrmageqcsv,sizenum);

%% Magnitude Distribution: Overall Completeness

catmagcomp(catalog,yrmageqcsv,s);

% Magnitude Distribution: 5 Year Completeness

% if sizenum == 1
%    catmagyrcomp(catalog,yrmageqcsv,s);
% end

%% Magnitude Distribution: Completeness Through Time

if sizenum == 1
    [compmag] = catmagcomphist(eqevents,catalog,yrmageqcsv,s);
end

%% Event Type Frequency

evtypetest(catalog,sizenum)

%% Searching for Duplicate Events

catdupsearch(catalog);

%% Possible Duplicate Events

catdupevents(catalog);

%% Largest Events

lrgcatevnts(catalog)

% Yearly Event Count List
% 
% dispyrcount(catalog,sizenum)

