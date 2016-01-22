%% *Problem Events*
% This page contains lists of all problem events.  The order of the lists
% is: events with depth residuals greater than the threshold, events with
% magnitude residuals greather than the threshold, and events with depth
% AND magnitude residuals greater than the thresholds.
FormatSpec1 = '%-10s %-20s %-8s %-9s %-7s %-3s %-7s \n';
FormatSpec2 = '%-10s %-20s %-8s %-9s %-7s %-3s \n';
%% _Summary of Depth Differences_
if ~isempty(dep.events1)
    disp(['There are ',num2str(size(dep.events1,1)),' events with different depths'])
    fprintf(FormatSpec1,'EventID', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag', 'Res(km)')
    for ii = 1 : size(dep.events1,1)
        fprintf(FormatSpec1,dep.ids{ii,1},datestr(dep.events1(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(dep.events1(ii,2)),num2str(dep.events1(ii,3)),num2str(dep.events1(ii,4)),num2str(dep.events1(ii,5)),num2str(dep.events1(ii,6)))
        fprintf(FormatSpec2,dep.ids{ii,2},datestr(dep.events2(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(dep.events2(ii,2)),num2str(dep.events2(ii,3)),num2str(dep.events2(ii,4)),num2str(dep.events2(ii,5)));
        disp('--')
    end
else
    disp('No events')
end
    disp(' ')
%% _Summary of Magnitude Differences_
if ~isempty(mags.events1)
    disp(['There are ',num2str(size(mags.events1,1)),' events with different magnitudes'])
    fprintf(FormatSpec1,'Catalog 1', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag', 'Res')
    for ii = 1 : size(mags.events1,1)
        fprintf(FormatSpec1,mags.ids{ii,1},datestr(mags.events1(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(mags.events1(ii,2)),num2str(mags.events1(ii,3)),num2str(mags.events1(ii,4)),num2str(mags.events1(ii,5)),num2str(mags.events1(ii,6)));
        fprintf(FormatSpec2,mags.ids{ii,2},datestr(mags.events2(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(mags.events2(ii,2)),num2str(mags.events2(ii,3)),num2str(mags.events2(ii,4)),num2str(mags.events2(ii,5)));
        disp('--')
    end
else
    disp('No events')
end
disp(' ')
FormatSpec1 = '%-10s %-20s %-8s %-9s %-7s %-3s %-7s %-7s\n';
FormatSpec2 = '%-10s %-20s %-8s %-9s %-7s %-3s \n';
%% _Summary of Depth AND Magnitude Differences_
if ~isempty(both.events1)
    disp(['There are ',num2str(size(both.events1,1)),' events with different depths'])
    fprintf(FormatSpec1,'Catalog 1', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag', 'DepRes','MagRes')
    for ii = 1 : size(both.events1,1)
        fprintf(FormatSpec1,both.ids{ii,1},datestr(both.events1(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(both.events1(ii,2)),num2str(both.events1(ii,3)),num2str(both.events1(ii,4)),num2str(both.events1(ii,5)),num2str(both.events1(ii,6)), num2str(both.events1(ii,7)))
        fprintf(FormatSpec2,both.ids{ii,2},datestr(both.events2(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(both.events2(ii,2)),num2str(both.events2(ii,3)),num2str(both.events2(ii,4)),num2str(both.events2(ii,5)));
        disp('--')
    end
else
    disp('No events')
end