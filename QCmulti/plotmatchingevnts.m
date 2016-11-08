function plotmatchingevnts(cat1, cat2, matching, reg)
% This function produces figures related to the matching events.  They
% include a map and histograms of the magnitude and depth distributions as
% well as of the magnitude, depth, time, and location residuals.
%
% Inputs -
%   cat1 - Catalog 1 information and data
%   cat2 - Catalog 2 information and data
%   matching - Matching event information
%   reg - Region of interest
%
% Output - NONE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Find min and max longitude of matching data
%
maxlon = max([matching.cat1.Longitude;matching.cat2.Longitude]);
minlon = min([matching.cat1.Longitude;matching.cat2.Longitude]);
%
% Check the range
%
if minlon<-170 && maxlon > 170
    %
    % Adjust event locations
    %
    for ii = 1 : length(matching.cat1.Longitude)
        if matching.cat1.Longitude(ii,3) < 0 
            matching_lon(ii) = matching.cat1.Longitude(ii) + 360;
        else
            matching_lon(ii) = matching.cat1.Longitude(ii);
        end
        if matching.cat2.Longitude(ii,3) < 0
            matching_lon2(ii) = matching.cat2.Longitude(ii)+360;
        else
            matching_lon2(ii) = matching.cat2.Longitude(ii);
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
    maxlat = max([matching.cat1.Latitude;matching.cat2.Latitude]); 
    minlat = min([matching.cat1.Latitude;matching.cat2.Latitude(:,2)]);
    midlat = (maxlat+minlat)/2;
    maxlon = max([matching_lon;matching_lon2]);
    minlon = min([matching_lon;matching_lon2]);
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
    h1 = plot(matching_lon,matching.cat1.Latitude,'.','Color',[1 1 1]);
    h2 = plot(matching_lon,matching.cat1.Latitude,'r.');
    h3 = plot(matching_lon2,matching.cat2.Latitude,'b.');
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
    title('MatchingEvents')
    legend([h1, h2, h3],['N=',num2str(size(matching.cat1,1))],cat1.name,cat2.name)
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
    % Plot matching events from catalog 1 and 2
    % Ghost plot for information in legend
    % 
    h1 = plot(matching.cat1.Longitude,matching.cat1.Latitude,'.','Color',[1 1 1]);
    h2 = plot(matching.cat1.Longitude,matching.cat1.Latitude,'r.');
    h3 = plot(matching.cat2.Longitude,matching.cat2.Latitude,'b.');
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
    axis([minlon maxlon minlat maxlat])
    midlat = (maxlat+minlat)/2;
    set(gca,'DataAspectRatio',[1,cosd(midlat),1])
    xlabel('Longitude','FontSize',14)
    ylabel('Latitude','FontSize',15)
    title('MatchingEvents')
    set(gca,'FontSize',15)
    legend([h1, h2, h3],['N=',num2str(size(matching.cat1,1))],cat1.name,cat2.name)
    box on
    hold off
    drawnow
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% catdensplot(matching,reg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotmatchingrose(matching,cat1.name,cat2.name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Histograms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mn = min([matching.cat1.Mag;matching.cat2.Mag])-0.05;
Mx = max([matching.cat1.Mag;matching.cat2.Mag])+0.05;
step = 0.1;
bins = Mn:step:Mx;
%
% Magnitude Distribution
%
figure
subplot(2,1,1)
hold on
histogram(matching.cat1.Mag,bins)
%
%Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Magnitudes from ',cat1.name],'FontSize',15)
title('Magnitudes for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
%
% Catalog 2
%
subplot(2,1,2)
hold on
histogram(matching.cat2.Mag,bins)
%
%Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Magnitudes from ',cat2.name],'FontSize',15)
title('Magnitudes for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Magnitude Comparison
%
p = polyfit(matching.cat2.Mag,matching.cat1.Mag,1);
[P] = polyval(p,matching.cat2.Mag);
R = corrcoef(P,matching.cat1.Mag);
R = R(1,2)^2;
figure
hold on
h1 = scatter(matching.cat2.Mag,matching.cat1.Mag);
h2 = plot(matching.cat2.Mag,P,'r-');
h3 = plot([0 9],[0 9],'k-');
%
% Bounds
%
Mins = min([matching.cat2.Mag;matching.cat1.Mag]);
Maxs = max([matching.cat2.Mag;matching.cat1.Mag]);
%
%Figure formatting
%
ylabel([cat1.name,' Magnitude'],'FontSize',15)
xlabel([cat2.name,' Magnitude'],'FontSize',15)
title('Magnitude Comparison','FontSize',15)
legend([h2,h3],['R^2 = ',num2str(R)],['B = 1'],'Location','NorthWest')
axis square
set(gca,'DataAspectRatio',[1,1,1])
axis([Mins Maxs Mins Maxs])
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Depth Distribution
%
Mn = min([matching.cat1.Depth;matching.cat2.Depth])-0.05;
Mx = max([matching.cat1.Depth;matching.cat2.Depth])+0.05;
step = 5;
bins = 0-step/2:step:Mx+step/2;
figure
subplot(2,1,1)
hold on
histogram(matching.cat1.Depth,bins)
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Depth (km) from ',cat1.name],'FontSize',15)
title('Depths for Matching Events','FontSize',15)
axis tight
box on
hold off
subplot(2,1,2)
hold on
histogram(matching.cat2.Depth,bins)
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Depth (km) from ',cat2.name],'FontSize',15)
title('Depths for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Depth Comparison
%
p = polyfit(matching.cat2.Depth,matching.cat1.Depth,1);
[P] = polyval(p,matching.cat2.Depth);
R = corrcoef(P,matching.cat1.Depth);
R = R(1,2)^2;
figure
hold on
h1 = scatter(matching.cat2.Depth,matching.cat1.Depth);
h2 = plot(matching.cat2.Depth,P,'r-');
B = polyval([1 0],matching.cat2.Depth);
h3 = plot(matching.cat2.Depth,B,'k-');
%
% Bounds
%
Mins = min([matching.cat2.Depth;matching.cat1.Depth]);
Maxs = max([matching.cat2.Depth;matching.cat1.Depth]);
%
%Figure formatting
%
ylabel([cat1.name,' Depth'],'FontSize',15)
xlabel([cat2.name,' Depth'],'FontSize',15)
title('Depth Comparison','FontSize',15)
legend([h2,h3],['R^2 = ',num2str(R)],['B = 1'],'Location','NorthWest')
axis([Mins Maxs Mins Maxs])
axis square
set(gca,'DataAspectRatio',[1,1,1])
box on
hold off
drawnow
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Time Residuals [86400 seconds in 1 day]
%
Time_convert = matching.cat1.delTime*86400; %Seconds
min_delT = min(Time_convert)-1.5;
max_delT = max(Time_convert)+1.5;
step = 0.1;
bins = min_delT:step:max_delT;
figure
hold on
histogram(matching.cat1.delTime*86400,bins)
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Time Residuals (s)',': ',cat1.name,'-',cat2.name],'FontSize',15)
title('Time Residuals for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Location (Distance Residuals)
%
min_delD = min(matching.cat1.delD)-0.5;
max_delD = max(matching.cat1.delD)+0.5;
step = 0.1;
bins = min_delD:step:max_delD;
figure
hold on
histogram(matching.cat1.delD,bins)
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Distance Residuals (km)',': ',cat1.name,'-',cat2.name],'FontSize',15)
title('Distance Residuals for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Magnitude Residuals
%
bins = min(matching.cat1.delMag)-0.05:0.1:max(matching.cat1.delMag)+0.05;
figure
hold on
histogram(matching.cat1.delMag,bins);
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Magnitude Residuals',': ',cat1.name,'-',cat2.name],'FontSize',15)
title('Magnitude Residuals for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Depth Residuals
%
min_delDp = min(matching.cat1.delDepth)-0.5;
max_delDp = max(matching.cat1.delDepth)+0.5;
step = 1;
bins = min_delDp:step:max_delDp;
figure
hold on
histogram(matching.cat1.delDepth,bins)
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Depth Residuals (km)',': ',cat1.name,'-',cat2.name],'FontSize',15)
title(['Depth Residuals for Matching Events'],'FontSize',15)
axis tight
box on
hold off
drawnow
%
% End of Function
%
end
