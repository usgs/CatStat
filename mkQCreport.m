%% Basic Catalog Summary

clear
close all

% Load Catalog
% pathname = 'Data/examplepde.csv'; %% This is a hardcoded directory that must be changed based on the user
% catalogname = 'PDE Catalog 1973-Present, Events > M5'; %% Also must be changed based on the user
 pathname = '../examplepdedays.csv'; %% This is a hardcoded directory that must be changed based on the user
 catalogname = 'PDE Catalog 2015-Present'; %% Also must be changed based on the user

catalog = loadlibcomcat(pathname,catalogname);
%catalog = loadkansas(pathname,catalogname);
%catalog = loadiscgemsupp(pathname,catalogname);

basiccatsum(catalog);

[sizenum] = catalogsize(catalog); 
% Used to determine if plots should be made by year or month or day based
% on catalog size
% Need to edit for possible few month long catalogs that span multiple years

%% Seismicity Map

plotcatmap(catalog);

%% Seismicity Density Plot

catdensplot(catalog);

%% Depth Distribution

plotcatdeps(catalog);

%% Event Frequency

eventfreq(catalog,sizenum);

% Hourly Event Frequency

%hreventfreq(catalog); % Make sure to edit the change in timezone for regional networks

%% Inter-Event Temporal Spacing

inteventspace(catalog,sizenum);

%% Magnitude Distribution: All Magnitudes

[yrmagcsv] = catmagdistrib(catalog,sizenum);

%% Magnitude Distribution: Yearly Median Magnitudes

[s] = plotyrmedmag(catalog,yrmagcsv,sizenum);

%% Magnitude Distribution: Overall Completeness

catmagcomp(catalog,yrmagcsv,s);

%% Magnitude Distribution: Completeness Through Time

if sizenum == 1
    [compmag] = catmagcomphist(catalog,yrmagcsv,s);
end
    
%% Searching for Duplicate Events

%catdupsearch(catalog);

%% Possible Duplicate Events

catdupevents(catalog);

%% Largest Events

lrgcatevnts(catalog)

%% Event Type Frequency

evtypetest(catalog,sizenum)

% Yearly Event Count List

%dispyrcount(catalog,sizenum)

