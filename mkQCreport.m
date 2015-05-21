%% Basic Catalog Summary

clear
close all

% Load Catalog
% pathname = 'Data/examplepde.csv'; %% This is a hardcoded directory that must be changed based on the user
% catalogname = 'PDE Catalog 1973-Present, Events > M5'; %% Also must be changed based on the user
pathname = '../examplepdedays.csv'; %% This is a hardcoded directory that must be changed based on the user
catalogname = 'PDE Catalog 2015-Present'; %% Also must be changed based on the user
% pathname = '../catap17'; %% This is a hardcoded directory that must be changed based on the user
% catalogname = 'PDE Catalog 1973-Present, Events > M5'; %% Also must be changed based on the user

catalog = loadlibcomcat(pathname,catalogname);
%catalog = loadkansas(pathname,catalogname);

basiccatsum(catalog);

[size] = catalogsize(catalog); % Used to determine if plots should be made by year or month (or day?) based on catalog size

%% Seismicity Map

plotcatmap(catalog);

%% Seismicity Density Plot

catdensplot(catalog);

%% Depth Distribution

plotcatdeps(catalog);

%% Event Frequency

eventfreq(catalog,size);

%% Hourly Event Frequency

hreventfreq(catalog); % Make sure to edit the change in timezone for regional networks

%% Inter-Event Temporal Spacing

inteventspace(catalog,size);

%% Magnitude Distribution: All Magnitudes

[yrmagcsv] = catmagdistrib(catalog,size);

%% Magnitude Distribution: Yearly Median Magnitudes

[s] = plotyrmedmag(catalog,yrmagcsv,size);

%% Magnitude Distribution: Overall Completeness

catmagcomp(catalog,yrmagcsv,s);

%% Magnitude Distribution: Completeness Through Time

if length(size) > 3
    [compmag] = catmagcomphist(catalog,yrmagcsv,s);
end
    
%% Searching for Duplicate Events

catdupsearch(catalog);

%% Possible Duplicate Events

catdupevents(catalog);

%% Largest Events

lrgcatevnts(catalog)
