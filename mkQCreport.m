%% Basic Catalog Summary

clear
close all

% Load Catalog
% pathname = 'Data/examplepde.csv'; %% This is a hardcoded directory that must be changed based on the user
% catalogname = 'PDE Catalog 1973-Present, Events > M5'; %% Also must be changed based on the user
% pathname = 'Data/examplepdeshrt.csv'; %% This is a hardcoded directory that must be changed based on the user
% catalogname = 'PDE Catalog 2013-Present'; %% Also must be changed based on the user
 pathname = '../sra_dev.csv'; %% This is a hardcoded directory that must be changed based on the user
 catalogname = 'SRA (Dev)'; %% Also must be changed based on the user

  catalog = loadlibcomcat(pathname,catalogname); % May need to check if milliseconds are indicated
% catalog = loadcomcatcsv(pathname,catalogname);
% catalog = loadkansas(pathname,catalogname);
% catalog = loadiscgemsupp(pathname,catalogname);
% catalog = loadisf(pathname,catalogname);
% catalog = loadenergycomcattemp(pathname,catalogname);
% catalog = loadakharley(pathname,catalogname);
% catalog = loadokdan(pathname,catalogname);
%  catalog = loadAFTAC(pathname,catalogname);

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

%hreventfreq(eqevents,catalog); % Make sure to edit the change in timezone for regional networks

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

%if sizenum == 1
%    catmagyrcomp(catalog,yrmageqcsv,s);
%end

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

%dispyrcount(catalog,sizenum)

