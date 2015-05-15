%% Multiple Catalog Comparison

clear
close all

% Load Catalog
pathname1 = 'Data/recentNSC.csv'; %% This is a hardcoded directory that must be changed based on the user
catname1 = 'National Seismic Centre - Nepal Events'; %% Also must be changed based on the user
pathname2 = 'Data/ComNepal.csv'; %% This is a hardcoded directory that must be changed based on the user
catname2 = 'ComCat Online Polygon Search CSV - Nepal Events'; %% Also must be changed based on the user

[cat1,cat2] = loadcatalogs(pathname1,catname1,pathname2,catname2); %% CHECK THIS! - Format of uploading must be changed based on catalog

%% Missing Events

time = 120; %sec
dist = 40; %km

missingevnts(cat1,cat2,time,dist);
%missingevnts(cat2,cat2,time,dist);

%% Matching Events

time = 120; %sec
dist = 40; %km

matchingevnts(cat1,cat2,time,dist);

