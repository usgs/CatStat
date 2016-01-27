%% *Missing Events*
% This page contains a list of all events missing from both catalogs.
% This events in catalog 1 missing from catalog 2 will be listed first,
% followed by the events in catalog 2 missing from catalog 1.
FormatSpec1 = '%-10s %-20s %-8s %-9s %-7s %-3s %-7s \n';
FormatSpec2 = '%-10s %-20s %-8s %-9s %-7s %-3s \n';
%% Catalog 1
% Summary of Missing Events
if ~isempty(missing.events1)
	disp(' ')
	disp('---------------------------------------------------')
	disp(['There are ',num2str(size(missing.events1,1)),' ',cat1.name,' events missing ']);
	disp(['from the ',num2str(size(cat2.data,1)),' events in ',cat2.name]);
	disp('---------------------------------------------------')
	disp(' ')
% List of Missing Events
	fprintf(FormatSpec2,'Event ID', 'Origin Time', 'Lat.','Lon.','Dep(km)', 'Mag')
	for ii = 1 : size(missing.events1,1)
		fprintf(FormatSpec2, missing.ids1{ii,1}, datestr(missing.events1(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(missing.events1(ii,2)),num2str(missing.events1(ii,3)),num2str(missing.events1(ii,4)),num2str(missing.events1(ii,5)))
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
% List of Missing Events
	fprintf(FormatSpec2,'Event ID', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag')
	for ii = 1 : size(missing.events2,1)
		fprintf(FormatSpec2, missing.ids2{ii,1}, datestr(missing.events2(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(missing.events2(ii,2)),num2str(missing.events2(ii,3)),num2str(missing.events2(ii,4)),num2str(missing.events2(ii,5)))
	end
else
	disp(' ')
	disp(['There are no ',cat2.name,' events missing from ',cat1.name])
	disp(' ')
end
%% Location Disagreement
%
if ~isempty(dist.events1)
	fprintf(FormatSpec1,'Event ID', 'Origin Time', 'Lat.','Lon.','Dep(km)', 'Mag','LocRes')
	for ii = 1 : size(dist.events1)
		fprintf(FormatSpec1,dist.ids1{ii,1}, datestr(dist.events1(ii,1),'yyyy/mm/dd HH:MM:SS'), num2str(dist.events1(ii,2)),num2str(dist.events1(ii,3)),num2str(dist.events1(ii,4)),num2str(dist.events1(ii,5)),num2str(dist.events1(ii,6)))
		fprintf(FormatSpec2,dist.ids1{ii,2}, datestr(dist.events2(ii,1),'yyyy/mm/dd HH:MM:SS'), num2str(dist.events2(ii,2)),num2str(dist.events2(ii,3)),num2str(dist.events2(ii,4)),num2str(dist.events2(ii,5)))
		disp(' -- ')
	end
else
	disp('No Events')
end
