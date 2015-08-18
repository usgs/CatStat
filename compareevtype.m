function [diffevtypes] = compareevtype(cat1,cat2,tmax,delmax)
% This function uses the matching events between the two compared catalogs
% and then compares their event types
% Input:
%  cat1,cat2 Two structures containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types

%         tmax: max time window to search for matching events [seconds]
%         delmax: max distence window to search for matching events [km] 

% Output: A matrix of events that are in both catalogs but have different
% event types between the two

% Finds matching events, then compares the event type and displays events
% that should have the same event type but do not

% Trim catalogs to be same time period
startdate = max(cat2.data(1,1),cat1.data(1,1))-tmax;
enddate = min(cat2.data(length(cat2.data),1),cat1.data(length(cat1.data),1))+tmax;
disp(['Overlapping time period: ',datestr(startdate),' to ',datestr(enddate)])
cat2.data(cat2.data(:,1)<startdate,:) = [];
cat1.data(cat1.data(:,1)<startdate,:) = [];
cat2.data(cat2.data(:,1)>enddate,:) = [];
cat1.data(cat1.data(:,1)>enddate,:) = [];

disp(['Cat1 post time trim: ',num2str(length(cat1.data(:,1)))])
disp(['Cat2 post time trim: ',num2str(length(cat2.data(:,1)))])

tmax = tmax/24/60/60;
delmax = delmax/111.12;

diffevtypes = [];
cat1diffevtype = {};
cat2diffevtype = {};

for ii = 1:length(cat1.data)
    %find time matches
    tdif = abs(cat1.data(ii,1)-cat2.data(:,1));
    timematch = cat2.data(tdif < tmax,:);
    evtypetimematch = cat2.evtype(tdif < tmax,1);
    
    %find distance matches for events with matching time
    if(isempty(timematch) == 0)
        for jj = 1:size(timematch,1)
            mindist = min(distance(cat1.data(ii,2:3),timematch(jj,2:3)));
            etcomp = strcmp(cat1.evtype{ii,1},evtypetimematch{jj,1});
            nucexp = strcmp(cat1.evtype{ii,1},'nuclear explosion');
            if(mindist > delmax) % Events match in time not distance
                if etcomp == 1 % Evtypes DO match
                    %disp([cat1.id{ii,1},' ',datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:)))),' ',cat1.evtype{ii,1}])
                    %disp([datestr(timematch(jj,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(timematch(jj,2:length(timematch(jj,:)))),' ',evtypetimematch{jj,1}])
                    %disp('Event type match');
                elseif etcomp == 0 && nucexp == 0 % Evtypes DO NOT match
                    disp('Match time not distance: ')
                    disp([cat1.id{ii,1},' ',datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:)))),' ',cat1.evtype{ii,1}])
                    disp([datestr(timematch(jj,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(timematch(jj,2:length(timematch(jj,:)))),' ',evtypetimematch{jj,1}])
                    disp('-----------------------')
                end
            else  % If events match in both time and distance, then compare evtype
                if etcomp == 1 % Evtypes DO match
                    %disp([cat1.id{ii,1},' ',datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:)))),' ',cat1.evtype{ii,1}])
                    %disp([datestr(timematch(jj,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(timematch(jj,2:length(timematch(jj,:)))),' ',evtypetimematch{jj,1}])
                    %disp('Event type match');
                elseif etcomp == 0 && nucexp == 0 % Evtypes DO NOT match
                    disp([cat1.id{ii,1},' ',datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:)))),' ',cat1.evtype{ii,1}])
                    disp([datestr(timematch(jj,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(timematch(jj,2:length(timematch(jj,:)))),' ',evtypetimematch{jj,1}])
                    disp('-----------------------')
                end
            end
            row1 = [cat1.data(ii,1:5)];
            row2 = [timematch(jj,1:5)];
            diffevtypes = [diffevtypes;row1];
            diffevtypes = [diffevtypes;row2];
            cat1diffevtype = strvcat(cat1diffevtype,cat1.evtype{ii,1});
            cat2diffevtype = strvcat(cat2diffevtype,evtypetimematch{jj,1});
        end
        %disp('-----------------------')
    end
    
     if(mod(ii,100000) == 0)
         disp(ii)
     end
end
