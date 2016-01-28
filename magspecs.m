function magspecs(yrmageqcsv)
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
count = 1;
M = length(yrmageqcsv(:,1));
disp('Magnitude statistics and distribution of earthquake events throughout the catalog. All other event types ignored.');
%
% Get catalog statistics
%
begyear = yrmageqcsv(1,1);
endyear = yrmageqcsv(M,1);
maxmag = ceil(max(yrmageqcsv(:,5)));
%
% Initialize Figure
%
figure
hold on
%
% Go through bin
%
xtick = begyear:1:endyear;
for mm = 1:maxmag
    index = find(yrmageqcsv(:,5) > (mm-1) & yrmageqcsv(:,5) <= mm);
    if size(index,1) > 0
        %
        % Subplot
        %
        subplot(maxmag,1,count)
        hold on
        plotmag = yrmageqcsv(index(:,1),:);
        [nn,xx] = hist(plotmag(:,1),xtick);
        bar(xx,nn)
        %
        % Format Options
        %
        ylabel([num2str(mm-1),'-',num2str(mm)])
close        set(gca,'linewidth',1.5)
        set(gca,'fontsize',12)
        set(gca,'XTick',xtick)
        hold off
        count = count +1;
    end
end
hold off
%
% End of function
%
end
