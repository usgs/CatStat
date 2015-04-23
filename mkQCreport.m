%% Catalog Information

clear
close all

% Load Catalog
pathname = '../ci_1900.csv'; %% This is a hardcoded directory that must be changed based on the user
catalogname = 'Southern Califorinia Seismic Network (CI)'; %% Also must be changed based on the user

catalog = loadlibcomcat(pathname,catalogname);

%% Basic Catalog Summary

basiccatsum(catalog);

%% Seismicity Map

plotcatmap(catalog);

%% Depth Distribution

plotcatdeps(catalog);

%% Event Frequency

eventfreq(catalog);

%% Hourly Event Frequency

hreventfreq(catalog);

%% Inter-Event Temporal Spacing

inteventspace(catalog);

%% Magnitude Distribution: All Magnitudes

[yrmagcsv] = catmagdistrib(catalog);

%% Magnitude Distribution: Yearly Median Magnitudes

[s] = plotyrmedmag(catalog,yrmagcsv);

%% Magnitude Distribution: Overall Completeness

catmagcomp(catalog,yrmagcsv,s);

%% Magnitude Distribution: Completeness Through Time

[compmag] = catmagcomphist(catalog,yrmagcsv,s);

%% Searching for Duplicate Events

catdupsearch(catalog);

%% Possible Duplicate Events

catdupevents(catalog);

%% Largest Events

lrgcatevnts(catalog);

%% Seismicity Density Plot

catdensplot(catalog,compmag);

