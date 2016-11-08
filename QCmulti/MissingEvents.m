%% *Missing Events*
% This page contains a list of all events missing from both catalogs.
% This events in catalog 1 missing from catalog 2 will be listed first,
% followed by the events in catalog 2 missing from catalog 1.
FormatSpec1 = '%-10s %-20s %-8s %-9s %-7s %-3s %-7s \n';
FormatSpec2 = '%-10s %-20s %-8s %-9s %-7s %-3s \n';
FormatSpec3 = '%-10s %-20s %-8s %-9s %-7s %-3s %-s \n';
P1 = {'http://earthquake.usgs.gov/earthquakes/eventpage/'};
P2 = {'#general_region'};
EventThres = 1000;
%% Catalog 1
% Summary of Missing Events
if ~isempty(missing.cat1) 
	disp(' ')
	disp('---------------------------------------------------')
	disp(['There are ',num2str(size(missing.cat1,1)),' ',cat1.name,' events missing ']);
	disp(['from the ',num2str(size(cat2.data,1)),' events in ',cat2.name]);
	disp('---------------------------------------------------')
	disp(' ')
    if size(missing.cat1,1) <= EventThres
    % List of Missing Events
        fprintf(FormatSpec3,'Event ID', 'Origin Time', 'Lat.','Lon.','Dep(km)', 'Mag','Link')
        for ii = 1 : size(missing.cat1,1)
            fprintf(FormatSpec3, missing.cat1.ID{ii}, ...
                datestr(missing.cat1.OriginTime(ii),'yyyy/mm/dd HH:MM:SS'),...
                num2str(missing.cat1.Latitude(ii)),...
                num2str(missing.cat1.Longitude(ii)),...
                num2str(missing.cat1.Depth(ii)),...
                num2str(missing.cat1.Mag(ii)),...
                strcat(P1{1},missing.cat1.ID{ii},P2{1}));
            disp('**')
            %Get closest three events
            TDiff = abs(missing.cat1.OriginTime(ii)-cat2.data.OriginTime);
            TDiff = table(TDiff);
            CLOSE=[TDiff,cat2.data];
            [CLOSE,sort_ind]=sortrows(CLOSE,1); % Will sort in ascending order according to column 1 (time diff)
            for jj = 1 : 3 % Print closest 3 events
                fprintf(FormatSpec2,CLOSE.ID{jj},num2str(CLOSE.TDiff(jj)*86400),...
                    num2str(missing.cat1.Latitude(ii)-CLOSE.Latitude(jj)),...
                    num2str(missing.cat1.Longitude(ii)-CLOSE.Longitude(jj)),...
                    num2str(missing.cat1.Depth(ii)-CLOSE.Depth(jj)),...
                    num2str(missing.cat1.Mag(ii)-CLOSE.Mag(jj)));
            end
            disp('--')
        end
    else
        disp('Missing Event list too long to display')
    end
else
	disp(' ')
	disp(['There are no ',cat1.name,' events missing from ',cat2.name])
	disp(' ')
end
%% Catalog 2
% Summary of Missing Events
if ~isempty(missing.cat2)
	disp(' ')
	disp('---------------------------------------------------')
	disp(['There are ',num2str(size(missing.cat2,1)),' ',cat2.name,' events missing ']);
	disp(['from the ',num2str(size(cat1.data,1)),' events in ',cat1.name]);
	disp('---------------------------------------------------')
	disp(' ')
    if size(missing.cat2,1) <= EventThres
    % List of Missing Events
        fprintf(FormatSpec3,'Event ID', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag','Link')
        for ii = 1 : size(missing.cat2,1)
            fprintf(FormatSpec3, missing.cat2.ID{ii}, ...
                datestr(missing.cat2.OriginTime(ii),'yyyy/mm/dd HH:MM:SS'),...
                num2str(missing.cat2.Latitude(ii)),...
                num2str(missing.cat2.Longitude(ii)),...
                num2str(missing.cat2.Depth(ii)),...
                num2str(missing.cat2.Mag(ii)),...
                strcat(P1{1},missing.cat2.ID{ii},P2{1}))
            disp('**')
            %Get closest three events
            TDiff = abs(missing.cat2.OriginTime(ii)-cat1.data.OriginTime);
            TDiff = table(TDiff);
            CLOSE=[TDiff,cat1.data];
            [CLOSE,sort_ind]=sortrows(CLOSE,1); % Will sort in ascending order according to column 1 (time diff)
            for jj = 1 : 3 % Print closest 3 events
                fprintf(FormatSpec2,CLOSE.ID{jj},num2str(CLOSE.TDiff(jj)*86400),...
                    num2str(missing.cat2.Latitude(ii)-CLOSE.Latitude(jj)),...
                    num2str(missing.cat2.Longitude(ii)-CLOSE.Longitude(jj)),...
                    num2str(missing.cat2.Depth(ii)-CLOSE.Depth(jj)),...
                    num2str(missing.cat2.Mag(ii)-CLOSE.Mag(jj)));
            end
            disp('--')
        end
    else
        disp('Missing Event list too long to display')
    end
else
	disp(' ')
	disp(['There are no ',cat2.name,' events missing from ',cat1.name])
	disp(' ')
end
% %% Location Disagreement
% %
% if ~isempty(dist.events1) && size(dist.events1,1)<= EventThres
% 	fprintf(FormatSpec1,'Event ID', 'Origin Time', 'Lat.','Lon.','Dep(km)', 'Mag','LocRes')
% 	for ii = 1 : size(dist.events1)
% 		fprintf(FormatSpec1,dist.ids1{ii,1}, datestr(dist.events1(ii,1),'yyyy/mm/dd HH:MM:SS'), num2str(dist.events1(ii,2)),num2str(dist.events1(ii,3)),num2str(dist.events1(ii,4)),num2str(dist.events1(ii,5)),num2str(dist.events1(ii,6)))
% 		fprintf(FormatSpec2,dist.ids1{ii,2}, datestr(dist.events2(ii,1),'yyyy/mm/dd HH:MM:SS'), num2str(dist.events2(ii,2)),num2str(dist.events2(ii,3)),num2str(dist.events2(ii,4)),num2str(dist.events2(ii,5)))
% 		disp(' -- ')
% 	end
% elseif ~isempty(dist.events1) && size(dist.events1,1)> EventThres
%     disp('List too long to display')
% else
% 	disp('No Events')
% end
