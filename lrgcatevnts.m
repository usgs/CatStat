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
sortmagcsv = sortrows(catalog.data,5);

disp(['The ',int2str(largestnum),' largest events within ', catalog.name])
disp(' ')

for ii = length(sortmagcsv)-(largestnum-1):length(sortmagcsv)
              disp([datestr(sortmagcsv(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(sortmagcsv(ii,2:5))])
              disp(' ')
end
