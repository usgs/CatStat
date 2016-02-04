function [matching,matchingids,matchingtypes] = matchingevnts(cat1,cat2,tmax,delmax)
% This function finds matching events between the two compared catalogs
% call: matchingevnts(cat1,cat2,tmax,delmax)
% Input:
%  cat1,cat2 Two structures containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types

%         tmax: max time window to search for matching events [seconds]
%         delmax: max distence window to search for matching events [km] 

% Output: A matrix of events from cat1 that match between the two catalogs

disp(' ')
disp('------- results from matchingevnts function ------ ')
disp(' ')
disp(['Time window: ',num2str(tmax),' Distance window: ',num2str(delmax)])
tmax = tmax/24/60/60;
%delmax = delmax/111.12;

% Trim catalogs to be same time period
startdate = max(cat2.data(1,1),cat1.data(1,1))-tmax;
enddate = min(cat2.data(length(cat2.data),1),cat1.data(length(cat1.data),1))+tmax;
disp(['Overlapping time period: ',datestr(startdate),' to ',datestr(enddate)])
% %disp('Trimming catalogs to same time range...')
% cat2.data(cat2.data(:,1)<startdate,:) = [];
% cat1.data(cat1.data(:,1)<startdate,:) = [];
% cat2.data(cat2.data(:,1)>enddate,:) = [];
% cat1.data(cat1.data(:,1)>enddate,:) = [];
% 
% % Trim catalogs to be the same region
% minlat = min(cat2.data(:,2))-1;
% maxlat = max(cat2.data(:,2))+1;
% minlon = min(cat2.data(:,3))-1;
% maxlon = max(cat2.data(:,3))+1;
% cat2.data(cat2.data(:,2)<minlat,:) = [];
% cat1.data(cat1.data(:,2)<minlat,:) = [];
% cat2.data(cat2.data(:,2)>maxlat,:) = [];
% cat1.data(cat1.data(:,2)>maxlat,:) = [];
% cat2.data(cat2.data(:,3)<minlon,:) = [];
% cat1.data(cat1.data(:,3)<minlon,:) = [];
% cat2.data(cat2.data(:,3)>maxlon,:) = [];
% cat1.data(cat1.data(:,3)>maxlon,:) = [];

disp(' ')
disp(['Looking for events in ',cat1.name,' (cat1) and '])
disp([cat2.name,' (cat2) that MATCH within ',num2str(tmax*24*3600),' seconds and '])
disp([num2str(delmax),' kilometers. Events are listed as cat1/cat2 pairs.'])

matching = [];
matchingids = [];
matchtimeonly = [];

for ii = 1:length(cat1.data)
    %find time matches
    tdif = abs(cat1.data(ii,1)-cat2.data(:,1));
    timematch = cat2.data(tdif < tmax,:);
    
    %find distance matches for events with matching time
    if(isempty(timematch) == 0)
        for jj = 1:size(timematch,1)
            mindist = min(distance_hvrsn(cat1.data(ii,2),cat1.data(:,3),timematch(jj,2),timematch(jj,3)));
            if(mindist > delmax)
                disp([datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:)))),' match time not distance: ',num2str(mindist)])
                disp([datestr(timematch(jj,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(timematch(jj,2:length(timematch(jj,:)))),' match time not distance: ',num2str(mindist),])
                % disp([num2str(mindist*111.12),' match time not distance: ',datestr(cat2(ii,1)),' ',num2str(cat2(ii,2:length(cat2(1,:))))])
                matchtimeonly = [matchtimeonly;cat1.data(ii,:)];
            else  % If match both time and distance
                disp([cat1.id{ii,1},' ',datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:))))])
                disp([datestr(timematch(jj,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(timematch(jj,2:length(timematch(jj,:))))])
                %disp([datestr(cat2(ii,1)),' ',num2str(cat2(ii,2:length(cat2(1,:))))])
                %matching= [matching;timematch(jj,:)];
                row = [cat1.data(ii,:),mindist*111.12,abs(cat1.data(ii,1)-timematch(jj,1))];
                matching = [matching;row];
                matchingids = [matchingids;cat1.id{ii,1}];
            end
            if size(timematch,1) > 1 && jj<size(timematch,1)
                disp(' ')
            end
        end
        disp('-----------------------')
    end
    
     if(mod(ii,100000) == 0)
         disp(ii)
     end
end

if size(matching,1) == 0;
    disp('no events with matching time and distance found.')
else
    disp(['There are ',num2str(size(matching,1)),' matching events '])
    disp(['in ',cat2.name]);
end
