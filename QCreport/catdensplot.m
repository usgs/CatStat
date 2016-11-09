function catdensplot(EQEvents,reg)
% This function creates a earthquake density map for the catalog
%
% Input: a structure containing catalog data
%         EQEvents -  data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type of earthquakes ONLY
%         catalog.reg - region
% Output: None
%
% Written By: Matthew R. Perry
% Last Edit: 07 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Boundaries
%
%
% Find min and max longitude of catalog events
%
coord = [];
region = [];
places = [];
[minlon, maxlon] = findMinMax(EQEvents.Longitude);
%
% Check to see if range goes over Pacific Transition Zone
%
if maxlon >= 180
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
    %
    %
    for ii = 1 : 2    
        figure('Color','w')
        hold on
        n = hist2d(EQEvents.Latitude,EQEvents.Longitude,100)';
        if ii == 2;
            n1 = log(n);
            mask = ~logical(filter2(ones(3),n1));
            n1(mask) = NaN;
            n1(n1==-Inf) = NaN;
            xb = linspace(minlon,maxlon,size(n1,1));
            yb = linspace(minlat,maxlat,size(n1,1));
            pcolor(xb,yb,n1);
            title('Log_{10} Density Plot')
        else
            n(n == 0) = NaN;
            xb = linspace(minlon,maxlon,size(n,1));
            yb = linspace(minlat,maxlat,size(n,1));
            pcolor(xb,yb,n);
            title('Density Plot')
        end
        %
        % Format Options
        %
        hchild=get(gca,'children'); %removes box outlines
        set(hchild,'edgecolor','none') %removes box outlines
        colormap(parula)
        colorbar
        set(gca,'fontsize',15)
        xlabel('Longitude');
        ylabel('Latitude');
        set(gca,'DataAspectRatio',[1,cosd(midlat),1])
        set(gca,'fontsize',15)
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
        axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
        set(gca,'XTick',X_Tick);
        set(gca,'XTickLabel',X_label);
        box on
        hold off
        drawnow
    end
else
    [minlat, maxlat] = findMinMax(EQEvents.Latitude);
    midlat = (maxlat+minlat)/2;
    [minlon, maxlon] = findMinMax(EQEvents.Longitude);
    latbuf = 0.1*(maxlat-minlat);
    lonbuf = 0.1*(maxlon-minlon);
    if strcmpi(reg,'all')
        X = 0;
        [poly(1,1), poly(2,1)] = findMinMax(EQEvents.Longitude);
        [poly(1,2), poly(2,2)] = findMinMax(EQEvents.Latitude);
    else
        X = 1;
        load('regions.mat')
        ind = find(strcmpi(region,reg));
        poly = coord{ind,1};
    end
    mapminlon = min(poly(:,1))-0.5;
    mapmaxlon = max(poly(:,1))+0.5;
    mapminlat = min(poly(:,2))-0.5;
    mapmaxlat = max(poly(:,2))+1.0;
    if minlon < -170 & maxlon > 170 & maxlat < 79 & minlat > -60
        mapmaxlon = -1*min(abs(EQEvents.data(:,3)));
        mapminlon = -180;
    end
    midlat = (mapmaxlat + mapminlat)/2;
    %
    % Density Plot and Log Density Plot
    %
    for ii = 1 : 2    
        figure('Color','w')
        hold on
        n = hist2d(EQEvents.Latitude,EQEvents.Longitude,100)';
        if ii == 2;
            n1 = log(n);
            mask = ~logical(filter2(ones(3),n1));
            n1(mask) = NaN;
            n1(n1==-Inf) = NaN;
            xb = linspace(minlon,maxlon,size(n1,1));
            yb = linspace(minlat,maxlat,size(n1,1));
            pcolor(xb,yb,n1);
            title('Log_{10} Density Plot')
        else
            n(n == 0) = NaN;
            xb = linspace(minlon,maxlon,size(n,1));
            yb = linspace(minlat,maxlat,size(n,1));
            pcolor(xb,yb,n);
            title('Density Plot')
        end
        %
        % Format Options
        %
        hchild=get(gca,'children'); %removes box outlines
        set(hchild,'edgecolor','none') %removes box outlines
        colormap(parula)
        colorbar
        set(gca,'fontsize',15)
        xlabel('Longitude');
        ylabel('Latitude');
        set(gca,'DataAspectRatio',[1,cosd(midlat),1])
        set(gca,'fontsize',15)
        plotworld
        if X == 1
            %
            % Plot region
            %
            plot(poly(:,1),poly(:,2),'k--','LineWidth',2)
        end
        axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
        box on
        hold off
        drawnow
    end
end
    function [min_data, max_data] = findMinMax(data)
        min_data = min(data);
        max_data = max(data);
    end
%
% End of Function
%
end
