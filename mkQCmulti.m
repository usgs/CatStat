%% Multiple Catalog Comparison

clear
close all

% Load Catalog
pathname1 = 'Data/recentNSC.csv'; %% This is a hardcoded directory that must be changed based on the user
catname1 = 'National Seismic Centre - Nepal Events'; %% Also must be changed based on the user
pathname2 = 'Data/ComNepal.csv'; %% This is a hardcoded directory that must be changed based on the user
catname2 = 'ComCat Online Polygon Search CSV - Nepal Events'; %% Also must be changed based on the user

[cat1,cat2] = loadcatalogs(pathname1,catname1,pathname2,catname2); %% CHECK THIS! - Format of uploading must be changed based on catalog

%% Duplicate Event Check? - May not be necessary because of single catalog code (mkQCreport)

% for kk = 1:2
%     if(kk == 1)
%         catalog = cat1;
%         catname = cat1name;
%     end
%     if(kk == 2)
%         catalog = cat2;
%         catname = cat2name;
%     end
% 
%     disp(['Looking for possible duplicate events in: ', catname] )
%     tmax = 1/24/60/60; % 1 second
%     delmax = 1/111.12; % 1 km
%     dup = 0;
%     for ii = 2:length(catalog)
%        if(abs(catalog(ii,1)-catalog(ii-1,1)) <= tmax)
%            if(distance(catalog(ii,2:3),catalog(ii-1,2:3)) <= delmax)
%               disp([datestr(catalog(ii-1,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(catalog(ii-1,2:7))])
%               disp([datestr(catalog(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(catalog(ii,2:7))])
%               disp('-----------------------')
%               dup = dup+1;
%            end
%        end
%     end
%     disp(['Finished looking for possible duplicate events in: ', catname] )
%     disp(['Possible duplicates: ',int2str(dup)])
%     disp(' ')
% end

%% Missing Events

time = 120; %sec
dist = 40; %km

missingevnts(cat1,cat2,time,dist);

%% Matching Events

time = 120; %sec
dist = 40; %km

matchingevnts(cat1,cat2,time,dist);

