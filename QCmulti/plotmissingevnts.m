function plotmissingevnts(cat1, cat2, missing, reg,timewindow)
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
if ~isempty(missing.cat1)
    maxlon = max(missing.cat1.Longitude);
    minlon = min(missing.cat1.Longitude);
    %
    % Check the range
    %
    if minlon < -170 && maxlon > 170
        %
        % Adjust missing event locations
        %
        for ii = 1 : size(missing.cat1,1)
            if missing.cat1.Longitude(ii)< 0
                missing.cat1.Longitude(ii) = missing.cat1.Longitude(ii) + 360;
            end
        end
        %
        % Adjust the world map
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
        maxlat = max(missing.cat1.Latitude); 
        minlat = min(missing.cat1.Latitude);
        midlat = (maxlat+minlat)/2;
        maxlon = max(missing.cat1.Longitude);
        minlon = min(missing.cat1.Longitude);
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
        % Plot Adjusted world map
        %
        figure; clf
        hold on
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
        % Plot Missing Events
        %
        h1 = plot(missing.cat1.Longitude,missing.cat1.Latitude,'.','Color',[1 1 1]);
        h2 = plot(missing.cat1.Longitude,missing.cat1.Latitude,'r.');
        %
        % Plot format
        %
        legend([h1,h2],['N=',num2str(size(missing.cat1,1))],cat1.name)
        axis([minlon maxlon minlat maxlat])
        set(gca,'DataAspectRatio',[1,cosd(midlat),1])
        xlabel('Longitude','FontSize',14)
        ylabel('Latitude','FontSize',15)
        set(gca,'FontSize',15)
        title(['Events in ',cat1.name,' that are NOT in ',cat2.name],'FontSize',14)
        box on
        hold off
        drawnow
    else
        %
        % Initiate figure
        %
        figure
        hold on
        %
        % Plot world map 
        %
        plotworld
        %
        % Plot catalog 1 events missing from catalog 2
        %
        h1 = plot(missing.cat1.Longitude,missing.cat1.Latitude,'.','Color',[1 1 1]);
        h2 = plot(missing.cat1.Longitude,missing.cat1.Latitude,'r.');

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
            minlon = min(poly(:,1))-0.5;
            maxlon = max(poly(:,1))+0.5;
            minlat = min(poly(:,2))-0.5;
            maxlat = max(poly(:,2))+1.0;
        %
        % Plot formatting
        %
        legend([h1,h2],['N=',num2str(size(missing.cat1,1))],cat1.name)
        axis([minlon maxlon minlat maxlat])
        midlat = (maxlat+minlat)/2;
        set(gca,'DataAspectRatio',[1,cosd(midlat),1])
        xlabel('Longitude','FontSize',14)
        ylabel('Latitude','FontSize',15)
        set(gca,'FontSize',15)
        title(['Events in ',cat1.name,' that are NOT in ',cat2.name],'FontSize',14)
        box on
        hold off
        drawnow
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Print Results
    %
    disp('---------------------------------------------------')
    disp([num2str(size(missing.cat1,1)),' events in ',cat1.name,' have no corresponding event in ',cat2.name,' within ', num2str(timewindow),' seconds.']);
    disp('---------------------------------------------------')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    % Histograms
    %
    % Histogram of Magnitude
    %
    min_mag = round(min(missing.cat1.Mag),1);
    max_mag = round(max(missing.cat1.Mag),1);
    bin_edges = min_mag-0.05:0.1:max_mag+0.05;
    figure
    hold on
    histogram(missing.cat1.Mag,bin_edges)
    %
    % Figure Formatting
    %
    ylabel('Count','FontSize',14)
    xlabel(['Magnitude from ',cat1.name],'FontSize',14)
    title(['Events in ',cat1.name,' that are NOT in ',cat2.name],'FontSize',12)
    axis tight
    box on
    hold off
    drawnow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    % Histogram of Depth
    %
    figure
    hold on
    histogram(missing.cat1.Depth)
    %
    % Figure Formatting
    %
    xlabel(['Depth (km) from ',cat1.name],'FontSize',14)
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
if ~isempty(missing.cat2)
    maxlon = max(missing.cat2.Longitude);
    minlon = min(missing.cat2.Longitude);
    %
    % Check the range
    %
    if minlon < -170 && maxlon > 170
        %
        % Adjust missing event locations
        %
        for ii = 1 : size(missing.cat2,1)
            if missing.events2(ii,3) < 0
                missing.events2(ii,3) = missing.events2(ii,3) + 360;
            end
        end
        %
        % Adjust the world map
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
        maxlat = max(missing.cat2.Latitude); 
        minlat = min(missing.cat2.Latitude);
        midlat = (maxlat+minlat)/2;
        maxlon = max(missing.cat2.Longitude);
        minlon = min(missing.cat2.Longitude);
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
        % Plot Adjusted world map
        %
        figure;clf;hold on
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
        % Plot Missing Events
        %
        h1 = plot(missing.cat2.Longitude,missing.cat2.Latitude,'.','Color',[1 1 1]);
        h2 = plot(missing.cat2.Longitude,missing.cat2.Latitude,'r.');
        %
        % Plot format
        %
        legend([h1,h2],['N=',num2str(size(missing.cat2,1))],cat2.name)
        axis([minlon maxlon minlat maxlat])
        set(gca,'DataAspectRatio',[1,cosd(midlat),1])
        xlabel('Longitude','FontSize',14)
        ylabel('Latitude','FontSize',15)
        set(gca,'FontSize',15)
        title(['Events in ',cat2.name,' that are NOT in ',cat1.name],'FontSize',14)
        box on
        hold off
        drawnow
    else
        figure
        hold on
        %
        % Plot world map
        %
        plotworld
        %
        % Plot catalog 1 events missing from catalog 2
        %
        h1 = plot(missing.cat2.Longitude,missing.cat2.Latitude,'.','Color',[1 1 1]);
        h2 = plot(missing.cat2.Longitude,missing.cat2.Latitude,'b.');
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
        minlon = min(poly(:,1))-0.5;
        maxlon = max(poly(:,1))+0.5;
        minlat = min(poly(:,2))-0.5;
        maxlat = max(poly(:,2))+1.0;
        %
        % Plot formatting
        %
        legend([h1,h2],['N=',num2str(size(missing.cat2,1))],cat2.name)
        axis([minlon maxlon minlat maxlat])
        midlat = (maxlat+minlat)/2;
        set(gca,'DataAspectRatio',[1,cosd(midlat),1])
        xlabel('Longitude','FontSize',14)
        ylabel('Latitude','FontSize',15)
        set(gca,'FontSize',15)
        title(['Events in ',cat2.name,' that are NOT in ',cat1.name],'FontSize',14)
        hold off
        drawnow
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Print Results
    %
    disp([num2str(size(missing.cat2,1)),' events in ',cat2.name, ' have no corresponding event in  ',cat1.name,' within ', num2str(timewindow),' seconds.'])
    disp('---------------------------------------------------')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    % Histograms
    %
    min_mag = round(min(missing.cat2.Mag),1);
    max_mag = round(max(missing.cat2.Mag),1);
    bin_edges = min_mag-0.05:0.1:max_mag+0.05;
    % Histogram of Magnitude
    %
    figure
    hold on
    histogram(missing.cat2.Mag,bin_edges)
    %
    % Figure Formatting
    %
    xlabel(['Magnitude from ',cat2.name],'FontSize',14)
    ylabel('Count','FontSize',14)
    title(['Events in ',cat2.name,' that are NOT in ',cat1.name],'FontSize',12)
    axis tight
    box on
    hold off
    drawnow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    % Histogram of Depth
    %
    figure
    hold on
    histogram(missing.cat2.Depth)
    %
    % Figure Formatting
    %
    xlabel(['Depth (km) from ',cat2.name],'FontSize',14)
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
