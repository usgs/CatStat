%% Multiple Catalog Comparison

clear
close all

% Load Catalog
pathname1 = 'Data_pe/recentNSC.csv'; %% This is a hardcoded directory that must be changed based on the user
catname1 = 'National Seismic Centre - Nepal Events'; %% Also must be changed based on the user
pathname2 = 'Data_pe/ComNepal.csv'; %% This is a hardcoded directory that must be changed based on the user
catname2 = 'ComCat Online Polygon Search CSV - Nepal Events'; %% Also must be changed based on the user

[cat1,cat2] = loadcatalogs(pathname1,catname1,pathname2,catname2); %% CHECK THIS! - Format of uploading must be changed based on catalog

%% Basic Statistics
basiccatsum(cat1);
basiccatsum(cat2);

%% Missing Events
missingevnts(cat1,cat2,120,40);
missingevnts(cat2,cat1,120,40);

%% Matching Events
[matching] = matchingevnts(cat1,cat2,120,60);

