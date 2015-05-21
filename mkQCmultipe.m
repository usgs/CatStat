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
pathname1 = '../nepal_for_paul.txt'; %% This is a hardcoded directory that must be changed based on the user
catname1 = 'International Data Centre - Nepal Events'; %% Also must be changed based on the user
cat1 = loadIDC(pathname1, catname1);

% load AFTAC catalog 
pathname2 = '../AFTAC.txt'; %% This is a hardcoded directory that must be changed based on the user
catname2 = 'Full AFTAC catalog'; %% Also must be changed based on the user
cat2= loadAFTAC(pathname2,catname2); 


%% Basic Statistics
basiccatsum(cat1);
basiccatsum(cat2);

timewindow = 120;
distwindow = 40;

setminlat = 26;
setmaxlat = 31;
setminlon = 79;
setmaxlon = 90;

setmaglim = 4;

%% Missing Events
[missing] = missingevnts(cat1,cat2,timewindow,distwindow,setminlat,setmaxlat,setminlon,setmaxlon,setmaglim);
%missingevnts(cat2,cat1,timewindow,distwindow,setminlat,setmaxlat,setminlon,setmaxlon);

%% Matching Events
[matching] = matchingevnts(cat1,cat2,timewindow,distwindow);
