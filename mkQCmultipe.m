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
% cat2 = loadcomcatcsv(pathname2,catname2);

% Load BackBone Catalog
 pathname2 = '../bb_pde.csv'; %% This is a hardcoded directory that must be changed based on the user
 catname2 = 'PDE Backbone'; %% Also must be changed based on the user
 cat2 = loadisf(pathname2,catname2);

% % Load ComCat Catalog
%  pathname1 = '../pde_803.csv'; %% This is a hardcoded directory that must be changed based on the user
%  catname1 = 'PDE ComCat 8-03'; %% Also must be changed based on the user
%  cat1 = loadcsv(pathname1,catname1); 
 
% Load ComCat Catalog
 pathname1 = '../pde_814.csv'; %% This is a hardcoded directory that must be changed based on the user
 catname1 = 'PDE ComCat'; %% Also must be changed based on the user
 cat1 = loadcsv(pathname1,catname1);

% load IDC catalog
% pathname1 = '../nepal_for_paul.txt'; %% This is a hardcoded directory that must be changed based on the user
% catname1 = 'International Data Centre - Nepal Events'; %% Also must be changed based on the user
% cat1 = loadIDC(pathname1,catname1);

% load AFTAC catalog 
% pathname2 = '../AFTAC_edit.txt'; %% This is a hardcoded directory that must be changed based on the user
% catname2 = 'Full AFTAC catalog'; %% Also must be changed based on the user
% cat2 = loadAFTAC(pathname2,catname2); 

% load GetCSV.py catalog 1
% pathname1 = '~/Desktop/ComCSV/iscgemsup_prod_720.csv'; %% This is a hardcoded directory that must be changed based on the user
% catname1 = 'ISC-GEM Supp. (Prod)'; %% Also must be changed based on the user
% cat1 = loadcsv(pathname1,catname1);

% load GetCSV.py catalog 2
% pathname2 = '~/Desktop/ComCSV/pde_prod_720.csv'; %% This is a hardcoded directory that must be changed based on the user
% catname2 = 'PDE (Prod)'; %% Also must be changed based on the user
% cat2 = loadisf(pathname2,catname2);
% cat2 = loadcsv(pathname2,catname2);

%% Basic Statistics
basiccatsum(cat1);
basiccatsum(cat2);

timewindow = 1; % Seconds
distwindow = 1; % Kilometers

setminlat = -90;
setmaxlat = 90;
setminlon = -180;
setmaxlon = 180;

setmaglim = -10; % This is a LOWER limit (no events BELOW this magnitude will be considered) - NEEDS EDITING?

%% Missing Events
[missing1,missing2,missingid1,missingid2] = missingevnts(cat1,cat2,timewindow,distwindow,setminlat,setmaxlat,setminlon,setmaxlon,setmaglim);
%missingevnts(cat2,cat1,timewindow,distwindow,setminlat,setmaxlat,setminlon,setmaxlon);

%% Matching Events
[matching,matchingids] = matchingevnts(cat1,cat2,timewindow,distwindow);

%% Event Type Comparison on Matching Events
[diffevtypes] = compareevtype(cat1,cat2,timewindow,distwindow);

%% Magnitude Comparison on Matching Events
[cat1diffmag,cat2diffmag] = comparemag(cat1,cat2,timewindow,distwindow);
