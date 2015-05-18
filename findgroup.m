function [group]] = findgroup((cat1,cat2,tmax,delmax)

% This function finds matching events between the two compared catalogs
% call: matchingevnts(cat1,cat2,tmax,delmax)
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types
% Output: group cell array of groups 

disp(' ')
disp('------- results from find groups function ------ ')
disp(' ')
disp(['Time window: ',num2str(tmax),' distance window: ',num2str(delmax)])
tmax = tmax/24/60/60;
delmax = delmax/111.12;

