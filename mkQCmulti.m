%% Multiple Catalog Comparison

clear
close all

[cat1,cat2] = loadmulticat;

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
