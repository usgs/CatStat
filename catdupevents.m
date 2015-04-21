function catdupevents(sortcsv,filename,id)
% This function finds and lists all the possible duplicate events within x seconds and x kilometers.
% Input: Sorted catalog matrix
% Output: None

secondsMax = 1;
kmMax = 1;
disp(['List of event pairs within ', num2str(secondsMax),' seconds and ', num2str(kmMax) ' kilometers'] )
disp(' ')
dup = 0;
for ii = 2:length(sortcsv)
       if(abs(sortcsv(ii,1)-sortcsv(ii-1,1)) <= secondsMax/24/60/60)
           if(distance(sortcsv(ii,2:3),sortcsv(ii-1,2:3)) <= kmMax/111.12)
              disp([datestr(sortcsv(ii-1,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',char(id(ii-1)),' ',num2str(sortcsv(ii-1,2:5))])
              disp([datestr(sortcsv(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',char(id(ii)),' ',num2str(sortcsv(ii,2:5))])
              disp('-----------------------')
              dup = dup+1;
           end
       end
end
disp(['Finished looking for possible duplicate events in: ', filename] )
disp(['Possible Duplicates: ',int2str(dup),' events within ', num2str(secondsMax),' seconds and ', num2str(kmMax) ' kilometers'])

