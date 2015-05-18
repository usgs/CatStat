function [] = missingevnts(cat1,cat2,tmax,delmax)
% This function find missing events from one catalog within the other -
% comparing both catalogs to each other.
% call missingevnts(cat1,cat2,tmax,delmax)
% Input: 
%  cat1,cat2 Two structures containing normalized catalog data

%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types

%         time       the given time window from the main script
%         dist       the given distance window from the main script

% tmax: max time window to search for matching events [seconds]
% delmax: max distence window to search for matching events [km]
%    

% Output: None.

disp(' ')
disp('------- results from missingevnts function ------ ')
disp(' ')
disp(['Looking for events in ',cat1.name,' that are NOT in ',cat2.name])
disp(['Time window: ',num2str(tmax),' distance window: ',num2str(delmax)])
tmax = tmax/24/60/60;
delmax = delmax/111.12;

% Trim catalogs to be same time period
startdate = max(cat2.data(1,1),cat1.data(1,1))-tmax;
enddate = min(cat2.data(length(cat2.data),1),cat1.data(length(cat1.data),1))+tmax;
disp(['Overlapping time period: ',datestr(startdate),' to ',datestr(enddate)])
%disp('Trimming catalogs to same time range...')
cat2.data(cat2.data(:,1)<startdate,:) = [];
cat1.data(cat1.data(:,1)<startdate,:) = [];
cat2.data(cat2.data(:,1)>enddate,:) = [];
cat1.data(cat1.data(:,1)>enddate,:) = [];

% trim catalogs to be the same region
minlat = min(cat2.data(:,2))-1;
maxlat = max(cat2.data(:,2))+1;
minlon = min(cat2.data(:,3))-1;
maxlon = max(cat2.data(:,3))+1;
cat2.data(cat2.data(:,2)<minlat,:) = [];
cat1.data(cat1.data(:,2)<minlat,:) = [];
cat2.data(cat2.data(:,2)>maxlat,:) = [];
cat1.data(cat1.data(:,2)>maxlat,:) = [];
cat2.data(cat2.data(:,3)<minlon,:) = [];
cat1.data(cat1.data(:,3)<minlon,:) = [];
cat2.data(cat2.data(:,3)>maxlon,:) = [];
cat1.data(cat1.data(:,3)>maxlon,:) = [];

notinref = [];
missingevents = [];

for ii = 1:length(cat1.data)
    %find for time matches
    tdif = abs(cat1.data(ii,1)-cat2.data(:,1));
    timematch = cat2.data(tdif < tmax,:);
    
    %find distance matches for events with matching time
    if(isempty(timematch))
        disp([datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:))))])
        missingevents = [missingevents;cat1.data(ii,:)];
     else %look for matching distance
        [tdel,tazi] = distance(cat1.data(ii,2:3),timematch(:,2:3));
        mindist = min(tdel);
        if(mindist > delmax)
          disp([datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:)))),' match time not distance: ',num2str(mindist*111.12)])
          missingevents = [missingevents;cat1.data(ii,:)];
        end
       %return
    end
    
    if(mod(ii,100000) == 0)
        disp(ii)
    end
   
end

if length(missingevents) == 0;
    disp('None found.')
else
    disp(['There are ',num2str(size(missingevents,1)),' missing events in ',cat2.name]);
    disp(['from the ',num2str(size(cat1.data,1)),' events in ',cat1.name]);
end
    
disp(' ')
disp(['Looking for events in ',cat2.name,' that are NOT in ',cat1.name])
disp(['Time window: ',num2str(tmax),' distance window: ',num2str(delmax)])
tmax = tmax/24/60/60;
delmax = delmax/111.12;

missingevents = [];
for ii = 1:length(cat2)
    
    %find for time matches
    tdif = abs(cat2.data(ii,1)-cat1.data(:,1));
    timematch = cat1.data(tdif < tmax,:);
    
    %find distance matches for events with matching time
    if(isempty(timematch))
        disp([datestr(cat2.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat2.data(ii,2:length(cat2.data(1,:))))])
        missingevents = [missingevents;cat2.data(ii,:)];
     else %look for matching distance
        [tdel,tazi] = distance(cat1.data(ii,2:3),timematch(:,2:3));
        mindist = min(tdel);
        if(mindist > delmax)
          disp([num2str(mindist*111.12),' match time not distance: ',datestr(cat2.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat2.data(ii,2:length(cat2.data(1,:))))])
          missingevents = [missingevents;cat2.data(ii,:)];
        end
       %return
    end
    
    if(mod(ii,100000) == 0)
        disp(ii)
    end
   
end

if length(missingevents) == 0;
    disp('None found.')
else
    disp(['There are ',num2str(size(missingevents,1)),' missing events in ',cat1.name]);
    disp(['from the ',num2str(size(cat2.data,1)),' events in ',cat2.name]);
end

