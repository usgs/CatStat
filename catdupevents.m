function [dups] = catdupevents(catalog)
% This function finds and lists all the possible duplicate events within x seconds and x kilometers.
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None
dups = [];
secondsMax = 2;
kmMax = 2;
magthres = -10;
disp(['List of event pairs within ', num2str(secondsMax),' seconds and ', num2str(kmMax) ' kilometers'] )
disp(' ')
D = 0;
dup = 0;
for ii = 2:length(catalog.data)
       if(abs(catalog.data(ii,1)-catalog.data(ii-1,1)) <= secondsMax/24/60/60)
           if(distance_hvrsn(catalog.data(ii,2), catalog.data(ii,3), catalog.data(ii-1,2), catalog.data(ii-1,3)) <= kmMax)
              if(catalog.data(ii,5) > magthres || catalog.data(ii-1,5) > magthres)
                disp([datestr(catalog.data(ii-1,1),'yyyy-mm-dd HH:MM:SS.FFF'),'  ',catalog.id{ii-1},' ',num2str(catalog.data(ii-1,2)),' ',num2str(catalog.data(ii-1,3)),' ',num2str(catalog.data(ii-1,4)),' ',num2str(catalog.data(ii-1,5))]);
                disp([datestr(catalog.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),'  ',catalog.id{ii},' ',num2str(catalog.data(ii,2)),' ',num2str(catalog.data(ii,3)),' ',num2str(catalog.data(ii,4)),' ',num2str(catalog.data(ii,5))]);
                disp('-----------------------')
                dup = dup+1;
                D = D + 2;
                dups{dup,1}=char(catalog.id{ii});
                delLoc(D-1,1) = distance_hvrsn(catalog.data(ii-1,2), catalog.data(ii-1,3), catalog.data(ii,2), catalog.data(ii,3));
                delLoc(D,1) = 0;
                delTime(D-1,1) = (catalog.data(ii-1,1)-catalog.data(ii,1))*86400;
                delTime(D,1) = 0;
                delDep(D-1,1) = catalog.data(ii-1,4) - catalog.data(ii,4);
                delDep(D,1) = 0;
                delMag(D-1,1) = catalog.data(ii-1,5) - catalog.data(ii,5);
                delMag(D,1) = 0;
                ind(D-1,1) = ii-1;
                ind(D,1) = ii;
              end
           end
       end
end
%
% Write .csv file if there are duplicates
%
if D~=0
    OriginTime = datestr(catalog.data(ind,1),'yyyy-mm-dd HH:MM:SS.FFF');
    EventID = catalog.id(ind,1);
    Lat = catalog.data(ind,2);
    Lon = catalog.data(ind,3);
    Depth = catalog.data(ind,4);
    Mag = catalog.data(ind,5);
    T = table(OriginTime,EventID,Lat,Lon,Depth,Mag,delTime,delLoc,delDep,delMag);
    writetable(T,'Duplicates.csv','Delimiter',',');
end
%
% Print out
%
disp(['Finished looking for possible duplicate events in: ', catalog.name])
disp(['Possible Duplicates: ',int2str(dup),' events within ', num2str(secondsMax),' seconds and ', num2str(kmMax) ' kilometers'])
%
% End of Function
%
end
