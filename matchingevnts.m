function [] = matchingevnts(cat1,cat2,time,dist)
% This function finds matching events between the two compared catalogs
% Input: a structure containing normalized catalog data & comparison window
% values
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types
%         time       the given time window from the main script
%         dist       the given distance window from the main script
% Output: None.

% Trim catalogs to be same time period
startdate = max(cat2.data(1,1),cat1.data(1,1));
enddate = min(cat2.data(length(cat2.data),1),cat1.data(length(cat1.data),1));
%disp(['Overlapping time period: ',datestr(startdate),' to ',datestr(enddate)])
%disp('Trimming catalogs to same time range...')
cat2.data(cat2.data(:,1)<startdate,:) = [];
cat1.data(cat1.data(:,1)<startdate,:) = [];
cat2.data(cat2.data(:,1)>enddate,:) = [];
cat1.data(cat1.data(:,1)>enddate,:) = [];

tmax = time/24/60/60;
delmax = dist/111.12;

disp(' ')
disp(['Looking for events in ',cat1.name,' (cat1) and '])
disp([cat2.name,' (cat2) that MATCH within ',num2str(time),' seconds and '])
disp([num2str(dist),' kilometers. Events are listed as cat1/cat2 pairs.'])
matchingevents = [];
for ii = 1:length(cat1.data)
    
    %find time matches
    tdif = abs(cat1.data(ii,1)-cat2.data(:,1));
    timematch = cat2.data(tdif < tmax,:);
    
    %find distance matches for events with matching time
    if(isempty(timematch) == 0)
        for jj = 1:size(timematch,1)
            mindist = min(distance(cat1.data(ii,2:3),timematch(jj,2:3)));
            if(mindist > delmax)
                disp([num2str(mindist*111.12),' match time not distance: ',datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:))))])
                disp([num2str(mindist*111.12),' match time not distance: ',datestr(timematch(jj,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(timematch(jj,2:length(timematch(jj,:))))])
                %disp([num2str(mindist*111.12),' match time not distance: ',datestr(cat2(ii,1)),' ',num2str(cat2(ii,2:length(cat2(1,:))))])
                matchingevents = [matchingevents;cat1.data(ii,:)];
            else  % If match both time and distance
                disp([datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:))))])
                disp([datestr(timematch(jj,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(timematch(jj,2:length(timematch(jj,:))))])
                %disp([datestr(cat2(ii,1)),' ',num2str(cat2(ii,2:length(cat2(1,:))))])
                matchingevents = [matchingevents;cat1.data(ii,:)];
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

if size(matchingevents,1) == 0;
    disp('None found.')
else
    disp(['There are ',num2str(size(matchingevents,1)),' matching events '])
    disp(['in ',cat2.name]);
end

