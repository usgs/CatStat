%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%QCmulti.m --
%Script to run in order to generate catalog comparison report.  Please
%refer to documentation for explanation on functions/algorithms used
%within.
%
%
%This script is typically run under to 'publish' function through
%mkQCmulti. Comments in the main script need cannot have a space after the percent symbol in
%order to remain unseen when report is published.  
%
%Comments inside subsequent functions are rendered normally and will not display on the
%report.  
%
%Mark-up is supported in the 'publish' function and any need to
%add or edit mark-up should follow the syntax discribed at 
%https://www.mathworks.com/help/matlab/matlab_prog/marking-up-matlab-comments-for-publishing.html
%
%Written By: Matthew R. Perry
%
%Last Edit: 07 November 2016
%For any issues, comments, or suggestions, please contact me through GitHub
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Note on Comments: To include comments in the HTML print out, there must be
%a space between the comment character and the comment itself (example
%below).  Please refer to the MATLAB documentation if HTML markup (i.e. formatted
%text is desired.
%% *Basic Catalog Statistics*
% 
[cat1,cat2] = loadmulticat(cat1,cat2);
%% _Catalog 1_
basiccatsum(cat1);
%% _Catalog 2_
basiccatsum(cat2);
%% *Comparison Criteria*
%Trim the catalog according to the input file
%
[cat1, cat2] = trimcats(cat1,cat2, reg, cat1.auth, maglim, timewindow,distwindow,magdelmax,depdelmax);
%Will only remove events with the same event ID, not spatiotemporal "duplicates"
%Remove duplicate event ids
cat1 = removeduplicates(cat1);
cat2 = removeduplicates(cat2);
%% *Map of Events*
% Map of all events in the overlapping time period that match the comparison criteria
plottrimcats(cat1,cat2, reg);
%% *Summary of Matching Events*
%Parsing matching and missing events
[missing, dist, dep, mags, both, matching] ...
    = compareevnts(cat1,cat2, timewindow,distwindow,magdelmax, ...
    depdelmax,cat1.auth,pubopts.outputDir);
%% *Time Series Summary of Catalog Events*
% This plot shows the data availabilty of the catalogs through time.
% Those time series with the label corresponding to the catalog name show
% the data available in that catalog.  Between those time ser94ies and the
% matching events are events in the respective catalog missing from the
% other catalog.  For example, if an X appears along the time line under
% the time series for the first catalog, that event is IN the first catalog
% but missing from the second catalog.  The middle time series shows the
% matching events.
plottimeseries(cat1, cat2, matching, missing)
%% *Matching events*
% The following <./MatchingEvents.html events> were determined to be 'matching' based on the thresholds
% defined in initMkQCmulti.dat.
if ~isempty(matching.cat1)
    plotmatchingres(matching, cat1.name, cat2.name);
    plotmatchingevnts(cat1, cat2, matching,reg);
%     compareEvType(matching);
else
    disp('No matching events.')
end
%% *Missing Events*
% For a complete list of missing events, please click <./MissingEvents.html here>
% 
disp('                  ---Total Missing Events---')
disp(' ')
disp(['There are ',num2str(size(missing.cat1,1)),' event(s) in ',cat1.name])
disp(['missing from ',cat2.name])
disp(' -- ')
disp(['There are ',num2str(size(missing.cat2,1)),' event(s) in ',cat2.name])
disp(['missing from ',cat1.name])
disp(' ')
%% _No Similar Origin Time_
if ~isempty(missing.cat1) || ~isempty(missing.cat2)
   plotmissingevnts(cat1, cat2, missing, reg,timewindow);
else
    disp('No missing events.')
end
% %% _Location Disagreement_ 
% disp('The following events had matching times, but the distance residuals')
% disp(['are greater than ',num2str(distwindow),' km.'])
% disp(' ')
% if ~isempty(dist.events1) || ~isempty(dist.events2)
%     plotdistevnts(cat1, cat2, dist, reg);
% else
%     disp('No events found with distance residuals greater than threshold.')
% end
%% *Potential Problem Events*
% The following <./ProblemEvents.html events> were determined to be
% potential problem events due to descrepencies between the two catalogs.
%
%% _Depth Differences_
disp(['The following events had matching times, locations, and magnitudes but the depth'])
disp(['residuals are greater than ',num2str(depdelmax),' km.'])
disp(' ')
if ~isempty(dep.cat1)
   plotdepevnts(cat1, cat2, dep, reg);
else
    disp('No events.')
end
%% _Magnitude Differences_
disp(['The following events had matching times, locations, and depths,'])
disp(['but the magnitide residuals are greater than ',num2str(magdelmax),'.'])
disp(' ')
if ~isempty(mags.cat1)
   plotmagsevnts(cat1, cat2, mags, reg);
else
    disp('No events.')
end
%% _Depth and Magnitude Differences_
disp(['The following events matched but the depth and magnitude residuals'])
disp(['were greater than ',num2str(depdelmax),' km and ',num2str(magdelmax),', respectively.'])
disp(' ')
if ~isempty(both.cat1)
    plotbothevnts(cat1,cat2, both, reg)
else
    disp('No events')
end
