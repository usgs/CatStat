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
% Get NaN and 0 magnitude event totals
%
NAN = sum(isnan(catalog.data(:,5)));
ZERO = sum(catalog.data(:,5)==0);
%
% Get unique events
%
U = unique(catalog.evtype);
U_count = zeros(size(U,1),1);
for ii = 1 : size(U,1)
   U_count(ii) = sum(strcmpi(catalog.evtype,U(ii)));
end
%
% Print Summary
%
fprintf(['Catalog Name:\t',catalog.name,'\n'])
fprintf(['File Name:\t',catalog.file,'\n'])
fprintf(['\n']);
fprintf(['First Date in Catalog:\t',begdate,'\n'])
fprintf(['Last Date in Catalog:\t',enddate,'\n'])
fprintf(['\n']);
fprintf(['Total Number of Events:\t',int2str(size(catalog.data,1)),'\n'])
for ii = 1 : size(U,1)
   fprintf(['\t',U{ii},':\t',int2str(U_count(ii)),'\n'])
end
fprintf(['\n']);
fprintf(['Minimum Latitude:\t',num2str(minlat),'\n'])
fprintf(['Maximum Latitude:\t',num2str(maxlat),'\n'])
fprintf(['Minimum Longitude:\t',num2str(minlon),'\n'])
fprintf(['Maximum Longitude:\t',num2str(maxlon),'\n'])
fprintf(['\n']);
fprintf(['Minimum Depth:\t',num2str(mindep),'\n'])
fprintf(['Maximum Depth:\t',num2str(maxdep),'\n'])
fprintf(['\n']);
fprintf(['Minimum Magnitude:\t',num2str(minmag),'\n'])
fprintf(['Maximum Magnitude:\t',num2str(maxmag),'\n'])
fprintf(['\n']);
fprintf(['Number of 0 magnitude events:\t',num2str(ZERO),'\n'])
fprintf(['Number of NaN magnitude events:\t',num2str(NAN),'\n'])
%
% End of function
%
end
