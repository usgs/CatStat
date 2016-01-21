%% *Basic Catalog Statistics*
% 
close all
[cat1,cat2] = loadmulticat(cat1,cat2);
%% _Catalog 1_
basiccatsum(cat1);
%
%% _Catalog 2_
basiccatsum(cat2);
%% *Comparison Criteria*
%Trim the catalog according to the input file
%
[cat1, cat2] = trimcats(cat1,cat2, reg, maglim, timewindow,distwindow,magdelmax,depdelmax);
%% *Summary Information*
%Parsing matching and missing events
%
[missing, dist, dep, mags, types, matching] = ...
    compareevnts(cat1,cat2,timewindow,distwindow,magdelmax,depdelmax);
%% *Matching events*
% The following events were determined to be 'matching' based on the thresholds
% defined in initMkQCmulti.dat.
if ~isempty(matching.data)
    plotmatchingevnts(cat1, cat2, matching,reg);
else
    disp('No matching events.')
end
%% *Location Differences*
% The following events had matching times, but the distance residuals
% are greater than the defined threshold.
%
if ~isempty(dist.events1) || ~isempty(dist.events2)
    plotdistevnts(cat1, cat2, dist, reg);
else
    disp('No events found with distance residuals greater than threshold.')
end
%% *Depth Differences*
% The following events had matching times and locations, but the depth
% residuals are greater than the defined threshold.
%
if ~isempty(dep.events1)
   plotdepevnts(cat1, cat2, dep, reg);
else
    disp('No events found with depth residuals greater than threshold.')
end
%% *Magnitude Differences*
% The following events had matching times, locations, and depths, but the
% magnitide residuals are greater than the defined threshold.
%
if ~isempty(mags.events1)
   plotmagsevnts(cat1, cat2, mags, reg);
else
    disp('No events found with magnitude residuals greater than threshold.')
end
%Event Type Differences
%SECTION NOT YET FINISHED
%% *Missing Events*
% To print out a list of missing events, please refer to the documentation
% for the plotmissingevnts_mp.m function (EL = 1).
%
if ~isempty(missing.events1) || ~isempty(missing.events2)
   plotmissingevnts(cat1, cat2, missing, reg, EL);
else
    disp('No missing events.')
end
% 


