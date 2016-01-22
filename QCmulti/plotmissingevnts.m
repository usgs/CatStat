function plotmissingevnts(cat1, cat2, missing, reg, EL)
% This function produces figures related to the missing events from each
% catalog.  They include maps and histograms.
%
% Inputs -
%   cat1 - Catalog 1 information and data
%   cat2 - Catalog 2 information and data
%   missing - Missing event data
%   reg - Region of interest
%   EL - Plot event list (yes or no)
%
% Output - NONE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Formatting variables for output
%
FormatSpec2 = '%-10s %-20s %-8s %-9s %-7s %-3s \n';
%
% Check if there are events from catalog 1 missing from catalog 2
%
if ~isempty(missing.events1)
    %
    % Initiate figure
    %
    figure
    hold on
    %
    % Plot world map and region
    %
    plotworld
    load('regions.mat');
    ind = find(strcmp(region,reg));
    poly = coord{ind,1};
    plot(poly(:,1),poly(:,2),'Color',[1 1 1]*0.25,'LineWidth',2);
    %
    % Plot catalog 1 events missing from catalog 2
    %
    h1 = plot(missing.events1(:,3),missing.events1(:,2),'Color',[1 1 1]);
    h2 = plot(missing.events1(:,3),missing.events1(:,2),'r.');
    %
    % Get minimum and maximum values for restricted axes
    %
    minlon = min(poly(:,1))-0.5;
    maxlon = max(poly(:,1))+0.5;
    minlat = min(poly(:,2))-0.5;
    maxlat = max(poly(:,2))+0.5;
    %
    % Plot formatting
    %
    legend([h1,h2],['N=',num2str(size(missing.events1,1))],cat1.name)
    axis([minlon maxlon minlat maxlat])
    midlat = (maxlat-minlat)/2;
    set(gca,'DataAspectRatio',[1,cosd(midlat),1])
    xlabel('Longitude','FontSize',14)
    ylabel('Latitude','FontSize',15)
    set(gca,'FontSize',15)
    title(['Events in ',cat1.name,' that are NOT in ',cat2.name],'FontSize',14)
    box on
    hold off
    drawnow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Print Results
    %
    disp('---------------------------------------------------')
    disp(['There are ',num2str(size(missing.events1,1)),' ',cat1.name,' events missing ']);
    disp(['from the ',num2str(size(cat2.data,1)),' events in ',cat2.name]);
    disp('---------------------------------------------------')
    %if strcmpi(EL,'yes')
    %
    % If EL=='yes', print out all missing events
    %
    %fprintf(FormatSpec2,'Event ID', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag')
    %for ii = 1 : size(missing.events1,1)
    %    fprintf(FormatSpec2, missing.ids1{ii,1}, datestr(missing.events1(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(missing.events1(ii,2)),num2str(missing.events1(ii,3)),num2str(missing.events1(ii,4)),num2str(missing.events1(ii,5)))
    %end
%    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Histograms
    %
    % Histogram of Magnitude
    %
    figure
    hold on
    histogram(missing.events1(:,5))
    %
    % Figure Formatting
    %
    ylabel('Count','FontSize',14)
    xlabel('Magnitude','FontSize',14)
    title(['Events in ',cat1.name,' that are NOT in ',cat2.name],'FontSize',12)
    axis tight
    box on
    hold off
    drawnow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Histogram of Depth
    %
    figure
    hold on
    histogram(missing.events1(:,4))
    %
    % Figure Formatting
    %
    xlabel('Depth (km)','FontSize',14)
    ylabel('Count','FontSize',14)
    title(['Events in ',cat1.name,' that are NOT in ',cat2.name],'FontSize',12)
    axis tight
    box on
    hold off
    drawnow
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Check if there are events from catalog 2 missing from catalog 1
%
if ~isempty(missing.events2)
    figure
    hold on
    %
    % Plot world map and region
    %
    plotworld
    load('regions.mat');
    ind = find(strcmp(region,reg));
    poly = coord{ind,1};
    plot(poly(:,1),poly(:,2),'Color',[1 1 1]*0.25,'LineWidth',2);
    %
    % Plot catalog 1 events missing from catalog 2
    %
    h1 = plot(missing.events2(:,3),missing.events2(:,2),'Color',[1 1 1]);
    h2 = plot(missing.events2(:,3),missing.events2(:,2),'b.');
    %
    % Get minimum and maximum values for restricted axes
    %
    minlon = min(poly(:,1))-0.5;
    maxlon = max(poly(:,1))+0.5;
    minlat = min(poly(:,2))-0.5;
    maxlat = max(poly(:,2))+0.5;
    %
    % Plot formatting
    %
    legend([h1,h2],['N=',num2str(size(missing.events2,1))],cat2.name)
    axis([minlon maxlon minlat maxlat])
    midlat = (maxlat-minlat)/2;
    set(gca,'DataAspectRatio',[1,cosd(midlat),1])
    xlabel('Longitude','FontSize',14)
    ylabel('Latitude','FontSize',15)
    set(gca,'FontSize',15)
    title(['Events in ',cat2.name,' that are NOT in ',cat1.name],'FontSize',14)
    hold off
    drawnow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Print Results
    %
    disp('---------------------------------------------------')
    disp(['There are ',num2str(size(missing.events2,1)),' ',cat2.name,' events missing ']);
    disp(['from the ',num2str(size(cat1.data,1)),' events in ',cat1.name]);
    disp('---------------------------------------------------')
%    if strcmpi(EL,'yes')
        %
        % If EL=='yes', print out all missing events
        %
%         fprintf(FormatSpec2,'Event ID', 'Origin Time', 'Lon.','Lat.','Dep(km)', 'Mag')
%    for ii = 1 : size(missing.events2,1)
%        fprintf(FormatSpec2, missing.ids2{ii,1}, datestr(missing.events2(ii,1),'yyyy/mm/dd HH:MM:SS'),num2str(missing.events2(ii,2)),num2str(missing.events2(ii,3)),num2str(missing.events2(ii,4)),num2str(missing.events2(ii,5)))
%    end
%    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Histograms
    %
    % Histogram of Magnitude
    %
    figure
    hold on
    histogram(missing.events2(:,5))
    %
    % Figure Formatting
    %
    xlabel('Magnitude','FontSize',14)
    ylabel('Count','FontSize',14)
    title(['Events in ',cat2.name,' that are NOT in ',cat1.name],'FontSize',12)
    axis tight
    box on
    hold off
    drawnow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Histogram of Depth
    %
    figure
    hold on
    histogram(missing.events2(:,4))
    %
    % Figure Formatting
    %
    xlabel('Depth (km)','FontSize',14)
    ylabel('Count','FontSize',14)
    title(['Events in ',cat2.name,' that are NOT in ',cat1.name],'FontSize',12)
    axis tight
    box on
    hold off
    drawnow
end
%
% End of Function
%
end
