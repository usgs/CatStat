%% Catalog Information

clear
close all

% Load Catalog
pathname = '~/Bulletins/Pde/Backbone/bb_hdf.csv'; %% This is a hardcoded directory that must be changed based on the user
catalogname = 'Hdf'; %% Also must be changed based on the user

catalog = loadbackbone(pathname,catalogname);

sortcsv = catalog.data;
id = catalog.id;
evtype = catalog.evtype;
filename = catalog.name;

%% Basic Catalog Summary

basiccatsum(sortcsv,evtype,filename);

%% Seismicity Map

plotcatmap(sortcsv);

%% Depth Distribution

plotcatdeps(sortcsv);

%% Event Frequency

eventfreq(sortcsv);

%% Inter-Event Temporal Spacing

inteventspace(sortcsv);

%% Magnitude Distribution: Through Time

[yrmagcsv,s] = catmagdistrib(sortcsv);

%% Magnitude Distribution: Completeness

catmagcomp(sortcsv,yrmagcsv,s);

%% Searching for Duplicate Events

catdupsearch(sortcsv);

%% Possible Duplicate Events

catdupevents(sortcsv,filename,id);

