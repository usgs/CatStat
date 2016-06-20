%% *Missing Events*
% This page contains a list of all events missing from both catalogs.
% This events in catalog 1 missing from catalog 2 will be listed first,
% followed by the events in catalog 2 missing from catalog 1.
FormatSpec1 = '%-10s %-20s %-8s %-9s %-7s %-3s %-7s \n';
FormatSpec2 = '%-10s %-20s %-8s %-9s %-7s %-3s \n';
FormatSpec3 = '%-10s %-20s %-8s %-9s %-7s %-3s %-s \n';
P1 = {'http://earthquake.usgs.gov/earthquakes/eventpage/'};
P2 = {'#general_region'};
EventThres = 10000;
%% Catalog 1
% Summary of Missing Events
if ~isempty(missing.events1) 
	disp(' ')
	disp('---------------------------------------------------')
	disp(['There are ',num2str(size(missing.events1,1)),' ',cat1.name,' events missing ']);
	disp(['from the ',num2str(size(cat2.data,1)),' events in ',cat2.name]);
	disp('---------------------------------------------------')
	disp(' ')
    if size(missing.events1,1) <= EventThres
    % List of Missing Events
        fprintf(FormatSpec3,'Event ID', 'Origin Time', 'Lat.','Lon.','Dep(km)', 'Mag','Link')
        for ii = 1 : size(missing.events1,1)
            fprintf(FormatSpec3, missing.ids1{ii,1}, ...
                datestr(missing.events1(ii,1),'yyyy/mm/dd HH:MM:SS'),...
                num2str(missing.events1(ii,2)),num2str(missing.events1(ii,3)),...
                num2str(missing.events1(ii,4)),num2str(missing.events1(ii,5)),...
                strcat(P1{1},missing.ids1{ii,:},P2{1}));
            disp('**')
            %Get closest three events
            close=[abs(missing.events1(ii,1)-cat2.data(:,1)),cat2.data(:,2:end)];
            [close,sort_ind]=sortrows(close,1); % Will sort in ascending order according to column 1 (time diff)
            close_id = cat2.id(sort_ind,:);
            for jj = 1 : 3 % Print closest 3 events
                fprintf(FormatSpec2,close_id{jj,1},num2str(close(jj,1)*86400),...
                    num2str(missing.events1(ii,2)-close(jj,2)),...
                    num2str(missing.events1(ii,3)-close(jj,3)),...
                    num2str(missing.events1(ii,4)-close(jj,4)),...
                    num2str(missing.events1(ii,5)-close(jj,5)));
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
if ~isempty(missing.events2)
	disp(' ')
	disp('---------------------------------------------------')
	disp(['There are ',num2str(size(missing.events2,1)),' ',cat2.name,' events missing ']);
	disp(['from the ',num2str(size(cat1.data,1)),' events in ',cat1.name]);
	disp('---------------------------------------------------')
	disp(' ')
    if size(missing.events2,1) <= EventThres
    % List of Missing Events
        fprintf(FormatSpec3,'Event ID', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag','Link')
        for ii = 1 : size(missing.events2,1)
            fprintf(FormatSpec3, missing.ids2{ii,1}, ...
                datestr(missing.events2(ii,1),'yyyy/mm/dd HH:MM:SS'),...
                num2str(missing.events2(ii,2)),num2str(missing.events2(ii,3)),...
                num2str(missing.events2(ii,4)),num2str(missing.events2(ii,5)),...
                strcat(P1{1},missing.ids2{ii,:},P2{1}))
            disp('**')
            %Get closest three events
            close=[abs(missing.events2(ii,1)-cat1.data(:,1)),cat1.data(:,2:end)];
            [close,sort_ind]=sortrows(close,1); % Will sort in ascending order according to column 1 (time diff)
            close_id = cat1.id(sort_ind,:);
            for jj = 1 : 3 % Print closest 3 events
                fprintf(FormatSpec2,close_id{jj,1},num2str(close(jj,1)*86400),...
                    num2str(missing.events2(ii,2)-close(jj,2)),...
                    num2str(missing.events2(ii,3)-close(jj,3)),...
                    num2str(missing.events2(ii,4)-close(jj,4)),...
                    num2str(missing.events2(ii,5)-close(jj,5)));
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
%% Location Disagreement
%
if ~isempty(dist.events1) && size(dist.events1,1)<= EventThres
	fprintf(FormatSpec1,'Event ID', 'Origin Time', 'Lat.','Lon.','Dep(km)', 'Mag','LocRes')
	for ii = 1 : size(dist.events1)
		fprintf(FormatSpec1,dist.ids1{ii,1}, datestr(dist.events1(ii,1),'yyyy/mm/dd HH:MM:SS'), num2str(dist.events1(ii,2)),num2str(dist.events1(ii,3)),num2str(dist.events1(ii,4)),num2str(dist.events1(ii,5)),num2str(dist.events1(ii,6)))
		fprintf(FormatSpec2,dist.ids1{ii,2}, datestr(dist.events2(ii,1),'yyyy/mm/dd HH:MM:SS'), num2str(dist.events2(ii,2)),num2str(dist.events2(ii,3)),num2str(dist.events2(ii,4)),num2str(dist.events2(ii,5)))
		disp(' -- ')
	end
elseif ~isempty(dist.events1) && size(dist.events1,1)> EventThres
    disp('List too long to display')
else
	disp('No Events')
end
