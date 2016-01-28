function basiccatsum(catalog)
% This function provides basic catalog information and statistics
% Input: a structure containing catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Beginning and end dates of the catalog
%
begdate = datestr(catalog.data(1,1),'yyyy-mm-dd HH:MM:SS.FFF');
enddate = datestr(catalog.data(size(catalog.data,1)),'yyyy-mm-dd HH:MM:SS.FFF');
%
% Maximum and minimum event latitude, longitude, depth, and magnitude
%
maxlat = max(catalog.data(:,2)); 
minlat = min(catalog.data(:,2));     
maxlon = max(catalog.data(:,3));     
minlon = min(catalog.data(:,3));
maxdep = max(catalog.data(:,4));
mindep = min(catalog.data(:,4)); 
maxmag = max(catalog.data(:,5));
minmag = min(catalog.data(:,5));
%
% Print Summary
%
disp(['Catalog Name: ',catalog.name])
disp([' ']);
disp(['First Date in Catalog: ',begdate])
disp(['Last Date in Catalog: ',enddate])
disp([' ']);
disp(['Total Number of Events: ',int2str(size(catalog.data,1))])
disp([' ']);
disp(['Minimum Latitude: ',num2str(minlat)])
disp(['Maximum Latitude: ',num2str(maxlat)])
disp(['Minimum Longitude: ',num2str(minlon)])
disp(['Maximum Longitude: ',num2str(maxlon)])
disp([' ']);
disp(['Minimum Depth: ',num2str(mindep)])
disp(['Maximum Depth: ',num2str(maxdep)])
disp([' ']);
disp(['Minimum Magnitude: ',num2str(minmag)])
disp(['Maximum Magnitude: ',num2str(maxmag)])
disp([' ']);
%disp(char(['Event types: ',unique(catalog.evtype)']))
%
% End of function
%
end
