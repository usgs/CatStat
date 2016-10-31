function magspecs(EQEvents)
% This function plots and compares the number of events of a specific magnitude. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

% Find events below increasing magnitude threshold and plot event count
%
%
%
time = datestr(EQEvents.OriginTime,'yyyy');
time = str2num(time);
Years = table(time);
yrmageqcsv = [Years,EQEvents];
count = 1;
M = size(yrmageqcsv.time,1);
disp('Magnitude statistics and distribution of earthquake events throughout the catalog. All other event types ignored.');
%
% Get catalog statistics
%
begyear = yrmageqcsv.time(1);
endyear = yrmageqcsv.time(M);
maxmag = ceil(max(yrmageqcsv.Mag));
%
% Initialize Figure
%
figure('Position',[500 500 650 700])
hold on
%
% Go through bin
%
xtick = begyear:1:endyear;
for mm = 1:maxmag
    index = find(yrmageqcsv.Mag > (mm-1) & yrmageqcsv.Mag <= mm);
    if size(index,1) > 0
        %
        % Subplot
        %
        subplot(maxmag,1,count)
        hold on
        plotmag = yrmageqcsv(index(:,1),:);
        [nn,xx] = hist(plotmag.time,xtick);
        bar(xx,nn)
        %
        % Format Options
        %
        ylabel([num2str(mm-1),'-',num2str(mm)])
        set(gca,'linewidth',1.5)
        set(gca,'fontsize',12)
        axis tight
        box on
        hold off
        count = count +1;
    end
end
box on
hold off
%
% End of function
%
end
