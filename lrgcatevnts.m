function lrgcatevnts(catalog)
% This function lists the largest events in the catalog based on a user
% defined amount. Default is top 10.
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
%         ** Hoping to add polygon for catalog as well
% Output: None

largestnum = 10;
catalog.data = sortrows(catalog.data,5);
nancount = sum(isnan(catalog.data(:,5)) | catalog.data(:,5) == -9.9);

disp(['The ',int2str(largestnum),' largest events within ', catalog.name])
disp(' ')

for ii = length(catalog.data)-(largestnum-1)-(nancount):length(catalog.data)-nancount
              fprintf('%s\t %10s\t %9.4f\t %8.4f\t %5.1f\t %4.1f\n',datestr(catalog.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),char(catalog.id(ii)),catalog.data(ii,2),catalog.data(ii,3),catalog.data(ii,4),catalog.data(ii,5))
              disp(' ')
end
