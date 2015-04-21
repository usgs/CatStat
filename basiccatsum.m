function basiccatsum(sortcsv,evtype,filename)
% This function provides basic information and statistics about the catalog 
% Input: Catalog information
% Output: None


begdate = datestr(sortcsv(1,1),'yyyy-mm-dd HH:MM:SS.FFF');
enddate = datestr(sortcsv(length(sortcsv),1),'yyyy-mm-dd HH:MM:SS.FFF');

M = length(sortcsv);

maxlat = max(sortcsv(:,2)); 
minlat = min(sortcsv(:,2));     
maxlon = max(sortcsv(:,3));     
minlon = min(sortcsv(:,3));
maxdep = max(sortcsv(:,4));
mindep = min(sortcsv(:,4)); 
nandepcount = sum(isnan(sortcsv(:,4)));
maxmag = max(sortcsv(:,5));
minmag = min(sortcsv(:,5));
zerocount = sum(sortcsv(:,5) == 0);
nancount = sum(isnan(sortcsv(:,5)) | sortcsv(:,5) == -9.9);

disp(['Catalog Name: ',filename])
disp([' ']);
disp(['First Date in Catalog: ',begdate])
disp(['Last Date in Catalog: ',enddate])
disp([' ']);
disp(['Total Number of Events: ',int2str(length(sortcsv))])
disp([' ']);
disp(['Minimum Latitude: ',num2str(minlat)])
disp(['Maximum Latitude: ',num2str(maxlat)])
disp([' ']);
disp(['Minimum Longitude: ',num2str(minlon)])
disp(['Maximum Longitude: ',num2str(maxlon)])
disp([' ']);
disp(['Minimum Depth: ',num2str(mindep)])
disp(['Maximum Depth: ',num2str(maxdep)])
disp([' ']);
disp(['Minimum Magnitude: ',num2str(minmag)])
disp(['Maximum Magnitude: ',num2str(maxmag)])
disp([' ']);
disp(char(['Event types: ',unique(evtype)']))

