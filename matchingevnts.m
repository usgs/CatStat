<<<<<<< HEAD
function [] = matchingevnts(cat1,cat2,time,dist)
% This function finds matching events between the two compared catalogs
% Input: a structure containing normalized catalog data & comparison window
% values
=======
function [matching] = matchingevnts(cat1,cat2,tmax,delmax)
% This function finds matching events between the two compared catalogs
% call: matchingevnts(cat1,cat2,tmax,delmax)
% Input: a structure containing normalized catalog data
>>>>>>> 710d0484095d8f1c8364129d9a8739a8ed57c81d
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types
%         time       the given time window from the main script
%         dist       the given distance window from the main script
% Output: None.

disp(' ')
disp('------- results from matchingevnts function ------ ')
disp(' ')
disp(['Time window: ',num2str(tmax),' distance window: ',num2str(delmax)])
tmax = tmax/24/60/60;
delmax = delmax/111.12;

% Trim catalogs to be same time period
<<<<<<< HEAD
startdate = max(cat2.data(1,1),cat1.data(1,1));
enddate = min(cat2.data(length(cat2.data),1),cat1.data(length(cat1.data),1));
%disp(['Overlapping time period: ',datestr(startdate),' to ',datestr(enddate)])
%disp('Trimming catalogs to same time range...')
=======
startdate = max(cat2.data(1,1),cat1.data(1,1))-tmax;
enddate = min(cat2.data(length(cat2.data),1),cat1.data(length(cat1.data),1))+tmax;
disp(['Overlapping time period: ',datestr(startdate),' to ',datestr(enddate)])
disp('Trimming catalogs to same time range...')
>>>>>>> 710d0484095d8f1c8364129d9a8739a8ed57c81d
cat2.data(cat2.data(:,1)<startdate,:) = [];
cat1.data(cat1.data(:,1)<startdate,:) = [];
cat2.data(cat2.data(:,1)>enddate,:) = [];
cat1.data(cat1.data(:,1)>enddate,:) = [];

<<<<<<< HEAD
tmax = time/24/60/60;
delmax = dist/111.12;

disp(' ')
disp(['Looking for events in ',cat1.name,' (cat1) and '])
disp([cat2.name,' (cat2) that MATCH within ',num2str(time),' seconds and '])
disp([num2str(dist),' kilometers. Events are listed as cat1/cat2 pairs.'])
matchingevents = [];
=======
disp(' ')
disp(['Looking for events in ',cat1.name,' (cat1) and '])

notinref = [];
matching = [];
matchtimeonly = [];
>>>>>>> 710d0484095d8f1c8364129d9a8739a8ed57c81d
for ii = 1:length(cat1.data)
    
    %find time matches
    tdif = abs(cat1.data(ii,1)-cat2.data(:,1));
    timematch = cat2.data(tdif < tmax,:);
    
    %find distance matches for events with matching time
    if(isempty(timematch) == 0)
        for jj = 1:size(timematch,1)
            mindist = min(distance(cat1.data(ii,2:3),timematch(jj,2:3)));
            if(mindist > delmax)
                disp([datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:)))),' match time not distance: ',num2str(mindist*111.12)])
                disp([datestr(timematch(jj,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(timematch(jj,2:length(timematch(jj,:)))),' match time not distance: ',num2str(mindist*111.12),])
                %disp([num2str(mindist*111.12),' match time not distance: ',datestr(cat2(ii,1)),' ',num2str(cat2(ii,2:length(cat2(1,:))))])
                matchtimeonly = [matchtimeonly;cat1.data(ii,:)];
            else  % If match both time and distance
                disp([datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:))))])
                disp([datestr(timematch(jj,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(timematch(jj,2:length(timematch(jj,:))))])
                %disp([datestr(cat2(ii,1)),' ',num2str(cat2(ii,2:length(cat2(1,:))))])
                matching= [matching;timematch(jj,:)]; 
                matching= [matching;cat1.data(ii,:)];
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
    disp('no events with mathing time and distance found.')
else
    disp(['There are ',num2str(size(matching,1)/2),' matching events '])
    disp(['in ',cat2.name]);
end
