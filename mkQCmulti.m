%% Multiple Catalog Comparison

clear
close all

% Load Nepal Catalog
% pathname1 = 'Data/recentNSC.csv'; %% This is a hardcoded directory that must be changed based on the user
% catname1 = 'National Seismic Centre - Nepal Events'; %% Also must be changed based on the user
% cat1 = loadNepal(pathname1,catname1); 

% Load ComCat Catalog
% pathname2 = 'Data/ComNepal.csv'; %% This is a hardcoded directory that must be changed based on the user
% catname2 = 'ComCat - Nepal Events'; %% Also must be changed based on the user
% cat2 = loadcomcatcsv(pathname1,catname1); 

% load IDC catalog
% pathname1 = '../nepal_for_paul.txt'; %% This is a hardcoded directory that must be changed based on the user
% catname1 = 'International Data Centre - Nepal Events'; %% Also must be changed based on the user
% cat1 = loadIDC(pathname1, catname1);

% load AFTAC catalog 
% pathname2 = '../AFTAC.txt'; %% This is a hardcoded directory that must be changed based on the user
% catname2 = 'Full AFTAC catalog'; %% Also must be changed based on the user
% cat2 = loadAFTAC(pathname2,catname2); 

% load GetCSV.py catalog 1
pathname1 = '../ushis.csv'; %% This is a hardcoded directory that must be changed based on the user
catname1 = 'USHIS Catalog'; %% Also must be changed based on the user
cat1 = loadcsv(pathname1, catname1);

% load GetCSV.py catalog 2
pathname2 = '../iscgemtest.csv'; %% This is a hardcoded directory that must be changed based on the user
catname2 = 'ISC GEM Catalog'; %% Also must be changed based on the user
cat2 = loadcsv(pathname2,catname2);


%% Basic Statistics
basiccatsum(cat1);
basiccatsum(cat2);

timewindow = 10;
distwindow = 100;

setminlat = 18;
setmaxlat = 70;
setminlon = -180;
setmaxlon = -50;

setmaglim = 0; % This is a LOWER limit (no events BELOW this magnitude will be considered)

%% Missing Events
[missing] = missingevnts(cat1,cat2,timewindow,distwindow,setminlat,setmaxlat,setminlon,setmaxlon,setmaglim);
%missingevnts(cat2,cat1,timewindow,distwindow,setminlat,setmaxlat,setminlon,setmaxlon);

%% Matching Events
[matching] = matchingevnts(cat1,cat2,timewindow,distwindow);
