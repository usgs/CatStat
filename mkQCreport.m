%% Catalog Information

clear
close all

% Load Catalog
pathname = '../ci_1900.csv'; %% This is a hardcoded directory that must be changed based on the user
catalogname = 'Southern Califorinia Seismic Network (CI)'; %% Also must be changed based on the user

catalog = loadlibcomcat(pathname,catalogname);

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

