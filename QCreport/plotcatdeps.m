function plotcatdeps(EQEvents,reg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function plots the distribution of event depth 
% Input: Necessary components described
%       EQEvents -  data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type of earthquakes ONLY
%       reg - region
%
% Output: 
%       No outputs
%
% Written by: Matthew R Perry
% Last Edit: 07 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
coord = [];
region = [];
places = [];
disp('Depth distribution of EARTHQUAKE EVENTS ONLY. All other event types ignored.');
%
% Replace any erroneous depths with NaN
%
ind = find(EQEvents.Depth==-999);
if ~isempty(ind);
    EQEvents(ind,:) = NaN;
end
%
% Get minimum and maximum depths
%
[mindep, maxdep] = findMinMax(EQEvents.Depth);
%
% Determine the number of events with NaN and 0km as depths and remove them
%
nandepcount = sum(isnan(EQEvents.Depth));
zerodepcount = sum(EQEvents.Depth == 0);
ind = find(isnan(EQEvents.Depth));
if ~isempty(ind);
    EQEvents(ind,:) = [];
end
ind = find(EQEvents.Depth == 0);
if ~isempty(ind);
    EQEvents(ind,:) = [];
end
%
% Print results
%
disp(['Minimum Depth: ',int2str(mindep)])
disp(['Maximum Depth: ',int2str(maxdep)])
disp(['Number of Events without a Depth: ',int2str(nandepcount)])
disp(['Number of Events with 0 km Depth: ',int2str(zerodepcount)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if sum(EQEvents.Depth >= 50) >= 1
    %
    % Shallow EQ
    %
    figure
    subplot(2,1,1)
    hold on
    histogram(EQEvents.Depth(EQEvents.Depth < 50))
    %
    % Format Options
    %
    set(gca,'fontsize',15)
    title('Shallow Earthquake Depth Histogram','fontsize',18)
    xlabel('Depth [km]','fontsize',18)
    ylabel('Number of Events','fontsize',18)
    axis tight;
    hold off
    drawnow
    %
    % Deep EQ
    %
    subplot(2,1,2)
    hold on
    y=histogram(EQEvents.Depth(EQEvents.Depth>=50));
    %
    %
    %
    set(gca,'fontsize',15)
    title('Deep Earthquake Depth Histogram','fontsize',18)
    xlabel('Depth [km]','fontsize',18)
    ylabel('Number of Events','fontsize',18)
    hold off
    drawnow
    %
    % Depth Map of EQ
    %
    [minlon, maxlon] = findMinMax(EQEvents.Depth);
    ind = find(EQEvents.Depth < 50);
    EQEvents(ind,:) = [];
    %
    % Check to see if range goes over Pacific Transition Zone
    %
   if maxlon >= 180
    %
    % Adjust event locations
    %
%     for ii = 1:length(EQEvents.Longitude)
%         if EQEvents.Longitude(ii) < 0
%             EQEvents.Longitude(ii) = EQEvents.Longitude(ii)+360;
%         end
%     end
    %
    % Adjust World Map
    %
    load('Countries.mat');
    L = length(places);
    for ii = 1 : L
        clon=lon{ii,1};
        for jj = 1 : length(clon)
            if clon(jj) < 0
                clon(jj) = clon(jj) + 360;
            end
        end
        clon(abs(diff(clon))>359) = NaN;
        lon{ii,1}=clon;
    end
    %
    % Adjust Region
    %
    if strcmpi(reg,'all')
        poly = [];
    else
        load('regions.mat')
        ind = find(strcmpi(region,reg));
        poly = coord{ind,1};
        for ii = 1 : length(poly);
            if poly(ii,1) < 0
                poly(ii,1) = poly(ii,1)+360;
            end
        end
        poly(abs(diff(poly(:,1)))>359,1) = NaN;
    end
    %
    % Get Boundaries
    %
    [minlat, maxlat] = findMinMax(EQEvents.Latitude);
    midlat = (maxlat+minlat)/2;
    [minlon, maxlon] = findMinMax(EQEvents.Longitude);
    latbuf = 0.1*(maxlat-minlat);
    lonbuf = 0.1*(maxlon-minlon);
    mapminlon = max(minlon-lonbuf,0);
    mapmaxlon = min(maxlon+lonbuf,360);
    mapminlat = max(minlat-latbuf,-90);
    mapmaxlat = min(maxlat+latbuf,90); 
    %
    % Get XTickLabel
    %
    X = round(linspace(minlon,maxlon,10));
    X_Tick = X;
    X(X>180) = X(X>180)-360;
    X_label = num2str(X');
    %
    % Make figure
    %
        figure
        hold on
        %
        % Plot Adjusted World Map
        %
        for ii = 1 : L
            plot(lon{ii,1},lat{ii,1},'k')
        end
        %
        % Plot Adjusted Region
        %
        if ~isempty(poly);
            plot(poly(:,1),poly(:,2),'k--','LineWidth',2)
        end
        %
        % Plot adjusted events
        %
        h1 = plot(EQEvents.Longitude,EQEvents.Latitude,'r.','MarkerSize',15);
        %
        % Plot Format
        %
        set(gca,'DataAspectRatio',[1,cosd(midlat),1])
        set(gca,'fontsize',15)
        axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
        set(gca,'XTick',X_Tick);
        set(gca,'XTickLabel',X_label);
        xlabel('Longitude')
        ylabel('Latitude')
        title(sprintf('Earthquakes >= 50 km depth'));
        legend(h1,'Earthquakes','Location','SouthOutside')
        hold off
    else
        % Initialize Figure
        %
        figure
        hold on
        plotworld
        %
        % Boundaries
        %
        if strcmpi(reg,'all')
            poly(1,1) = min(EQEvents.Longitude);
            poly(2,1) = max(EQEvents.Longitude); 
            poly(1,2) = min(EQEvents.Latitude);
            poly(2,2) = max(EQEvents.Latitude);
        else
            load('regions.mat')
            ind = find(strcmpi(region,reg));
            poly = coord{ind,1};
            %
            % Plot region
            %
            plot(poly(:,1),poly(:,2),'k--','LineWidth',2)
        end
        %
        % Plot earthquakes (red) and non-earthquake events (blue)
        %
        h1 = plot(EQEvents.Longitude,EQEvents.Latitude,'r.','MarkerSize',15);
        minlon = min(poly(:,1))-0.5;
        maxlon = max(poly(:,1))+0.5;
        minlat = min(poly(:,2))-0.5;
        maxlat = max(poly(:,2))+1.0;
        midlat = (maxlat + minlat)/2;
        %
        % Format Options
        %
        title(sprintf('Earthquakes >= 50 km depth'));
        legend(h1,sprintf('Earthquakes')','Location','SouthOutside')
        ylabel('Latitude')
        xlabel('Longitude')
        axis([minlon maxlon minlat maxlat]);
        set(gca,'DataAspectRatio',[1,cosd(midlat),1])
        set(gca,'fontsize',15)
        box on
        hold off
        drawnow
   end
    %
    % Print Out
    %
    if size(EQEvents.Depth(EQEvents.Depth>=50),1) <= 20
        GT50 = EQEvents(EQEvents.Depth>=50,:);
        disp(' ')
        disp('            Events Deeper than 50 km')
        disp('-------------------------------------------------')
        for ii = 1 : size(GT50,1)
            fprintf('%s\t%s\tM%s\t%s\n',GT50.ID{ii},datestr(GT50.OriginTime(ii)),...
                num2str(GT50.Mag(ii)),num2str(GT50.Depth(ii)));
        end
    end
else
    figure
    hold on
    histogram(EQEvents.Depth)
    %
    % Format Options
    %
    set(gca,'fontsize',15)
    title('Earthquake Depth Histogram','fontsize',18)
    xlabel('Depth [km]','fontsize',18)
    ylabel('Number of Events','fontsize',18)
    axis tight;
    hold off
    drawnow
end
    function [min_data, max_data] = findMinMax(data)
        min_data = min(data);
        max_data = max(data);
    end
%
%End of Function
%
end