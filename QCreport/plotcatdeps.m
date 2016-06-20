function plotcatdeps(eqevents,reg)
% This function plots the distribution of event depth 
% Input:  eqevents - Only earthquake events from the original catalog
%         
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
disp('Depth distribution of EARTHQUAKE EVENTS ONLY. All other event types ignored.');
%
% Replace any erroneous depths with NaN
%
eqevents(eqevents(:,4)==-999,4) = NaN;
%
% Get minimum and maximum depths
%
maxdep = max(eqevents(:,4));
mindep = min(eqevents(:,4));
%
% Determine the number of events with NaN and 0km as depths and remove them
%
nandepcount = sum(isnan(eqevents(:,4)));
zerodepcount = sum(eqevents(:,4) == 0);
eqevents(isnan(eqevents(:,4)),:) = [];
eqevents(eqevents(:,4) == 0,:) = [];
%
% Print results
%
disp(['Minimum Depth: ',int2str(mindep)])
disp(['Maximum Depth: ',int2str(maxdep)])
disp(['Number of Events without a Depth: ',int2str(nandepcount)])
disp(['Number of Events with 0 km Depth: ',int2str(zerodepcount)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if sum(eqevents(:,4)>=50) >= 1
    %
    % Shallow EQ
    %
    figure
    subplot(2,1,1)
    hold on
    histogram(eqevents(eqevents(:,4) < 50,4))
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
    y=histogram(eqevents(eqevents(:,4)>=50,4));
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
    maxlon = max(eqevents(:,3));
    minlon = min(eqevents(:,3));
    eqevents(eqevents(:,4)<50,:) = [];
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
        maxlat = max(eqevents(:,2))+0.5; 
        minlat = min(eqevents(:,2))-0.5;
        midlat = (maxlat+minlat)/2;
        maxlon = max(eqevents(:,3))+0.5;
        minlon = min(eqevents(:,3))-0.5;
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
        %
        % Plot adjusted events
        %
        h1 = plot(eqevents(:,3),eqevents(:,2),'r.','MarkerSize',15);
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
        %
        % Plot earthquakes (red) and non-earthquake events (blue)
        %
        h1 = plot(eqevents(:,3),eqevents(:,2),'rx','MarkerSize',15);
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
else
    figure
    hold on
    histogram(eqevents(:,4))
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
%
%End of Function
%
end