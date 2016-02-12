%% *Matching Events*
% This page contains a list of all matching events.
%
FormatSpec1 = '%-20s %-20s %-8s %-9s %-7s %-7s %-7s %-7s %-7s %-7s\n';
FormatSpec2 = '%-20s %-20s %-8s %-9s %-7s %-7s \n';
%% _Summary_
disp('----- Matching Events -----')
disp(' ')
disp([num2str(size(matching.data,1)),' ',cat1.name,' and ',cat2.name, ' meet matching criteria.'])
disp(' ')
fprintf(FormatSpec1,'Event ID', 'Origin Time','Lat.','Lon.','Dep(km)','Mag','LocRes','DepRes','magRes','TimeRes')
for ii = 1 : size(matching.data,1)
	fprintf(FormatSpec1,matching.ids{ii,1}, datestr(matching.data(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(matching.data(ii,2)),num2str(matching.data(ii,3)),num2str(matching.data(ii,4)),num2str(matching.data(ii,5)),num2str(matching.data(ii,6)), num2str(matching.data(ii,7)),num2str(matching.data(ii,8)),num2str(matching.data(ii,9)*86400));
	fprintf(FormatSpec2,matching.ids{ii,2}, datestr(matching.data2(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(matching.data2(ii,2)),num2str(matching.data2(ii,3)),num2str(matching.data2(ii,4)),num2str(matching.data2(ii,5)));
	disp('----')
end

