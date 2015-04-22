function catdupevents(catalog)
% This function finds and lists all the possible duplicate events within x seconds and x kilometers.
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

secondsMax = 1;
kmMax = 1;
disp(['List of event pairs within ', num2str(secondsMax),' seconds and ', num2str(kmMax) ' kilometers'] )
disp(' ')
dup = 0;
for ii = 2:length(catalog.data)
       if(abs(catalog.data(ii,1)-catalog.data(ii-1,1)) <= secondsMax/24/60/60)
           if(distance(catalog.data(ii,2:3),catalog.data(ii-1,2:3)) <= kmMax/111.12)
              disp([datestr(catalog.data(ii-1,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',char(catalog.id(ii-1)),' ',num2str(catalog.data(ii-1,2:5))])
              disp([datestr(catalog.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',char(catalog.id(ii)),' ',num2str(catalog.data(ii,2:5))])
              disp('-----------------------')
              dup = dup+1;
           end
       end
end
disp(['Finished looking for possible duplicate events in: ', catalog.name] )
disp(['Possible Duplicates: ',int2str(dup),' events within ', num2str(secondsMax),' seconds and ', num2str(kmMax) ' kilometers'])

