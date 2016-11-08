function [EQEvents, nonEQEvents] = plotcatmap(catalog)
% This function creates a seismicity map for the catalog, including bounds 
% Input: Necessary components described
%       catalog - a structure containing catalog data (described in loadcat)
%       catalog.name - Name of the catalog
%       catalog.data - data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type
%       catalog.reg  - Selected region
%
% Output: 
%       EQEvents -- subset of catalog.data where the event type is equal to
%       'earthquake'
%       nonEQEvents -- subsets of catalog.data where the event type is not
%       equal to 'earthquake'
%
% Written by: Matthew R Perry
% Last Edit: 07 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Map of recorded catalog activity distinguished between earthquakes (red) and overlaying non earthquakes (blue).']);
%
% Find min and max longitude of catalog events
%
coord = [];
region = [];
lat = [];
lon = [];
places = [];
[minlon,maxlon] = findMinMax(catalog.data.Longitude);
%
% Check to see if range goes over Pacific Transition Zone
%
if minlon < -170 & maxlon > 170
    %
    % Adjust event locations
    %
    for ii = 1:length(catalog.data.Longitude)
        if catalog.data.Longitude(ii) < 0
            catalog.data.Longitude(ii) = catalog.data.Longitude(ii)+360;
        end
    end
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
    if strcmpi(catalog.reg,'all')
        poly = [];
    else
        load('regions.mat')
        ind = find(strcmpi(region,catalog.reg));
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
    [minlat, maxlat] = findMinMax(catalog.data.Latitude);
    midlat = (maxlat+minlat)/2;
    [minlon, maxlon] = findMinMax(catalog.data.Longitude);
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
    % Separate Events
    %
    [EQEvents, nonEQEvents] = getEQ(catalog.data);    
    %
    % Initialize Figure
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
    h1 = plot(EQEvents.Longitude,EQEvents.Latitude,'r.');
    h2 = plot(nonEQEvents.Longitude,nonEQEvents.Latitude,'b.');
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
    title(catalog.name);
    if isempty(h2)
        legend(h1,'Earthquakes','Location','NorthOutside')
    else
        legend([h1, h2],'Earthquakes','Other Events','Location','NorthOutside')
    end
    hold off
else
    [EQEvents, nonEQEvents] = getEQ(catalog.data);
    %
    % Initialize Figure
    %
    figure
    hold on
    plotworld
    %
    % Plot earthquakes (red) and non-earthquake events (blue)
    %
    h1 = plot(EQEvents.Longitude,EQEvents.Latitude,'r.');
    h2 = plot(nonEQEvents.Longitude,nonEQEvents.Latitude,'b.');
    %
    % Boundaries
    %
    if strcmpi(catalog.reg,'all')
        [poly(1,1), poly(2,1)] = findMinMax(catalog.data.Longitude);
        [poly(1,2), poly(2,2)] = findMinMax(catalog.data.Latitude);
    else
        load('regions.mat')
        ind = find(strcmpi(region,catalog.reg));
        poly = coord{ind,1};
        %
        % Plot region
        %
        plot(poly(:,1),poly(:,2),'k--','LineWidth',2)
    end
    minlon = min(poly(:,1))-0.5;
    maxlon = max(poly(:,1))+0.5;
    minlat = min(poly(:,2))-0.5;
    maxlat = max(poly(:,2))+1.0;
    midlat = (maxlat + minlat)/2;
    %
    % Format Options
    %
    if isempty(h2)
        legend(h1,'Earthquakes','Location','NorthOutside')
    else
        legend([h1, h2],'Earthquakes','Other Events','Location','NorthOutside')
    end
    ylabel('Latitude')
    xlabel('Longitude')
    axis([minlon maxlon minlat maxlat]);
    set(gca,'DataAspectRatio',[1,cosd(midlat),1])
    set(gca,'fontsize',15)
    box on
    hold off
    drawnow
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Internal Functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [min_data, max_data] = findMinMax(data)
        min_data = min(data);
        max_data = max(data);
    end

    function [EQEvents, nonEQEvents] = getEQ(data)
        EQEvents = data(strncmpi('earthquake',data.Type,10),:);
        nonEQEvents = data(~strncmpi('earthquake',data.Type,10),:);
    end
%
% End of function
%
end