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
[nn,~] = sortrows(catalog.data,5);
nancount = sum(isnan(catalog.data.Mag) | catalog.data.Mag == -9.9);

disp(['The ',int2str(largestnum),' largest events within ', catalog.name])
disp(' ')

for ii = size(nn,1)-nancount:-1:size(nn,1)-(largestnum-1)-(nancount)
              disp([(datestr(nn.OriginTime(ii),'yyyy-mm-dd HH:MM:SS.FFF')),'  ',nn.ID{ii},' ',num2str(nn.Latitude(ii)),' ',num2str(nn.Longitude(ii)),' ',num2str(nn.Depth(ii)),' ',num2str(nn.Mag(ii))])
              disp(' ')
end
end
