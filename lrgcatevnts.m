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
[nn,ii] = sortrows(catalog.data,5);
catalog.id = catalog.id(ii);
nancount = sum(isnan(catalog.data(:,5)) | catalog.data(:,5) == -9.9);

disp(['The ',int2str(largestnum),' largest events within ', catalog.name])
disp(' ')

for ii = length(nn)-nancount:-1:length(nn)-(largestnum-1)-(nancount)
              %fprintf('%s\t %10s\t %9.4f\t %8.4f\t %5.1f\t %4.1f\n',datestr(nn(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),char(catalog.id(ii)),nn(ii,2),nn(ii,3),nn(ii,4),nn(ii,5))
              disp([(datestr(nn(ii,1),'yyyy-mm-dd HH:MM:SS.FFF')),'  ',catalog.id{ii},' ',num2str(nn(ii,2)),' ',num2str(nn(ii,3)),' ',num2str(nn(ii,4)),' ',num2str(nn(ii,5))])
              disp(' ')
end
