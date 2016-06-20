function [eqevents,eqevents_ids]=plotdeepevents(eqevents,eqevents_ids,reg,DP)
% This function creates a seismicity map for the catalog, including bounds 
% Input: a structure containing catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
%         ** Hoping to add polygon for catalog as well
%
% Output: eqevents  A matrix of ONLY earthquakes from the original catalog
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sprintf('Map of Earthquakes with depths greater than %.0f km.',DP);
%
% Find min and max longitude of catalog events
%
eqevents = eqevents(eqevents(:,4) >= DP,:);
eqevents_ids = eqevents_ids(eqevents(:,4) >= DP,:);
%
%
%
maxlon = max(eqevents(:,3));
minlon = min(eqevents(:,3));
%
% Check to see if range goes over Pacific Transition Zone
%
if minlon < -170 && maxlon > 170
    %
    % Adjust event locations
    %
    for ii = 1:length(eqevents(:,3))
        if eqevents(ii,3) < 0
            eqevents(ii,3) = eqevents(ii,3)+360;
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
    maxlat = max(eqevents(:,2)); 
    minlat = min(eqevents(:,2));
    midlat = (maxlat+minlat)/2;
    maxlon = max(eqevents(:,3));
    minlon = min(eqevents(:,3));
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
    eqevents = eqevents(strncmpi('earthquake',eqevents.evtype,10),:);
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
    h1 = plot(eqevents(:,3),eqevents(:,2),'r.');
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
    title(eqevents.name);
    legend(h1,'Earthquakes','Location','NorthOutside')
    hold off
else
    % Initialize Figure
    %
    figure
    hold on
    plotworld
    %
    % Plot earthquakes (red) and non-earthquake events (blue)
    %
    h1 = plot(eqevents(:,3),eqevents(:,2),'r.');
    %
    % Boundaries
    %
    if strcmpi(reg,'all')
        poly(1,1) = min(eqevents(:,3));
        poly(2,1) = max(eqevents(:,3)); 
        poly(1,2) = min(eqevents(:,2));
        poly(2,2) = max(eqevents(:,2));
    else
        load('regions.mat')
        ind = find(strcmpi(region,reg));
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
    legend(h1,sprintf('Earthquakes > %.0f km depth',DP)','Location','NorthOutside')
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
% End of function
%
end