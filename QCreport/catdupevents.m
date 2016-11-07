function [dups] = catdupevents(catalog,secondsMax,kmMax,magthres)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function finds and lists all the possible duplicate events within
% x seconds and x kilometers.
%
% Input: Necessary components described
%       catalog.data -  data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type
%       catalog.name - Name of the catalog
%       secondsMax - Time window for duplicates
%       kmMax - Distance window for duplicates
%       magthres - Magnitude above which duplicates should be considered.
%
% Output: Table of Event IDs for possble duplicates.
%
% Written by: Matthew R Perry
% Last Edit: 07 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dups = [];
disp(['List of event pairs within ', num2str(secondsMax),' seconds and ', num2str(kmMax) ' kilometers'] )
disp(' ')
D = 0;
dup = 0;
for ii = 2:size(catalog.data,1)
       if(abs(catalog.data.OriginTime(ii)-catalog.data.OriginTime(ii-1)) <= secondsMax/24/60/60)
           if(distance_hvrsn(catalog.data.Latitude(ii), ...
                   catalog.data.Longitude(ii),...
                   catalog.data.Latitude(ii-1),...
                   catalog.data.Longitude(ii-1)) <= kmMax)
              if(catalog.data.Mag(ii) > magthres || catalog.data.Mag(ii-1) > magthres)
                disp([datestr(catalog.data.OriginTime(ii-1),'yyyy-mm-dd HH:MM:SS.FFF'),'  ',catalog.data.ID{ii-1},' ',num2str(catalog.data.Latitude(ii-1)),' ',num2str(catalog.data.Longitude(ii-1)),' ',num2str(catalog.data.Depth(ii-1)),' ',num2str(catalog.data.Mag(ii-1))]);
                disp([datestr(catalog.data.OriginTime(ii),'yyyy-mm-dd HH:MM:SS.FFF'),'  ',catalog.data.ID{ii},' ',num2str(catalog.data.Latitude(ii)),' ',num2str(catalog.data.Longitude(ii)),' ',num2str(catalog.data.Depth(ii)),' ',num2str(catalog.data.Mag(ii))]);
                disp('-----------------------')
                dup = dup+1;
                D = D + 2;
                dups{dup,1}=char(catalog.data.ID{ii});
                delLoc(D-1,1) = distance_hvrsn(catalog.data.Latitude(ii-1), catalog.data.Longitude(ii-1), catalog.data.Latitude(ii), catalog.data.Longitude(ii));
                delLoc(D,1) = 0;
                delTime(D-1,1) = (catalog.data.OriginTime(ii-1)-catalog.data.OriginTime(ii))*86400;
                delTime(D,1) = 0;
                delDep(D-1,1) = catalog.data.Depth(ii-1) - catalog.data.Depth(ii);
                delDep(D,1) = 0;
                delMag(D-1,1) = catalog.data.Mag(ii-1) - catalog.data.Mag(ii);
                delMag(D,1) = 0;
                ind(D-1,1) = ii-1;
                ind(D,1) = ii;
              end
           end
       end
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
