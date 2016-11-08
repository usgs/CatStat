function plottrimcats(cat1, cat2, reg)
%
% Function that plots the results from trimcats.m
%
% Inputs -
%   cat1 - Catalog 1 structure (from trimcats)
%   cat2 - Catalog 2 structure (fron trimcats)
%   reg - Region of interest (originally from initQCMulti.dat)
%
% Outputs - None 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Find min and max longitude
%
maxlon = max(max(cat1.data.Longitude),max(cat2.data.Longitude));
minlon = min(min(cat1.data.Longitude),min(cat2.data.Longitude));
%
% Check to see if range goes over Pacific Transition Zone
%
if minlon < -170 && maxlon > 170
    %
    % Adjust event locations
    % Catalog 1
    for ii = 1 : length(cat1.data.Longitude)
        if cat1.data.Longitude(ii) < 0
            cat1.data.Longitude(ii) = cat1.data.Longitude(ii)+360;
        end
    end
    % Catalog 2
    for ii = 1 : length(cat2.data.Longitude)
        if cat2.data.Longitude(ii) < 0
            cat2.data.Longitude(ii) = cat2.data.Longitude(ii)+360;
        end
    end
    %
    % Adjust World Map
    %
    load('Countries.mat')
    lon = [];
    lat = [];
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
    maxlat = max([cat1.data.Latitude;cat2.data.Latitude])+.5; 
    minlat = min([cat1.data.Latitude;cat2.data.Latitude])-.5;
    midlat = (maxlat+minlat)/2;
    maxlon = max([cat1.data.Longitude;cat2.data.Longitude])+.5;
    minlon = min([cat1.data.Longitude;cat2.data.Longitude])-.5;
    mapminlon = max(minlon,0);
    mapmaxlon = min(maxlon,360);
    mapminlat = max(minlat,-90);
    mapmaxlat = min(maxlat,90); 
    %
    % Get XTickLabel
    %
    X = round(linspace(minlon,maxlon,10));
    X_Tick = X;
    X(X>180) = X(X>180)-360;
    X_label = num2str(X');
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
    h1 = plot(cat1.data.Longitude,cat1.data.Latitude,'r.');
    h2 = plot(cat2.data.Longitude,cat2.data.Latitude,'b.');
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
    title(['Comparison of ',cat1.name,' and ',cat2.name],'FontSize',14)
    legend([h1 h2],[cat1.name,'--',num2str(size(cat1.data,1))],[cat2.name,'--',num2str(size(cat2.data,1))])
    box on
    hold off
    drawnow
else
    %
    % Initiate Figure
    %
    figure
    hold on
    %
    % Function that plots the world map
    %
    plotworld
    %
    % Plot Catalog 1 data
    %
    h1 = plot(cat1.data.Longitude,cat1.data.Latitude,'r.');
    %
    % Plot Catalog 2 data
    %
    h2 = plot(cat2.data.Longitude,cat2.data.Latitude,'b.');
    %
    % Restrict to Region of interest
    % Get minimum and maximum values for restricted axes
    %
    load('regions.mat')
    if strcmpi(reg,'all')
        poly(1,1) = min([cat1.data.Longitude;cat2.data.Longitude]);
        poly(2,1) = max([cat1.data.Longitude;cat2.data.Longitude]);
        poly(1,2) = min([cat1.data.Latitude;cat2.data.Latitude]);
        poly(2,2) = max([cat1.data.Latitude;cat2.data.Latitude]);
    else
        ind = find(strcmpi(region,reg));
        poly = coord{ind,1};
        %
        % Plot region
        %
        plot(poly(:,1),poly(:,2),'k--','LineWidth',2)
    end
    minlon = min(poly(:,1))-1.5;
    maxlon = max(poly(:,1))+1.5;
    minlat = min(poly(:,2))-1.5;
    maxlat = max(poly(:,2))+2.0;
    %
    % Plot formatting
    %
    legend([h1 h2],[cat1.name,'--',num2str(size(cat1.data,1))],[cat2.name,'--',num2str(size(cat2.data,1))])
    axis([minlon maxlon minlat maxlat])
    midlat = (maxlat+minlat)/2;
    set(gca,'DataAspectRatio',[1,cosd(midlat),1])
    xlabel('Longitude','FontSize',14)
    ylabel('Latitude','FontSize',15)
    set(gca,'FontSize',15)
    title(['Comparison of ',cat1.name,' and ',cat2.name],'FontSize',14)
    box on
    hold off
    drawnow
    %
    % End of Function
    %
end