%% Multiple Catalog Comparison

clear
close all

% Load Nepal Catalog
%pathname1 = 'Data_pe/recentNSC.csv'; %% This is a hardcoded directory that must be changed based on the user
%catname1 = 'National Seismic Centre - Nepal Events'; %% Also must be changed based on the user
%cat1 = loadNepal(pathname1,catname1); 

% Load ComCat Catalog
pathname1 = 'Data_pe/ComNepal.csv'; %% This is a hardcoded directory that must be changed based on the user
catname1 = 'ComCat - Nepal Events'; %% Also must be changed based on the user
cat1 = loadcomcatcsv(pathname1,catname1); 

% load AFTAC catalog 
pathname2 = 'Data_pe/AFTAC.txt'; %% This is a hardcoded directory that must be changed based on the user
catname2 = 'Full AFTAC catalog'; %% Also must be changed based on the user
cat2= loadAFTAC(pathname2,catname2); 

%% Basic Statistics
basiccatsum(cat1);
basiccatsum(cat2);

timewindow = 60;
distwindow = 40;

%% Missing Events
missingevnts(cat1,cat2,timewindow,distwindow);
missingevnts(cat2,cat1,timewindow,distwindow);

%% Matching Events
[matching] = matchingevnts(cat1,cat2,timewindow,distwindow);
