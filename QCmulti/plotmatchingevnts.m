function plotmatchingevnts_new(cat1, cat2, matching, reg)
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
maxlon = max(matching.data(:,3));
minlon = min(matching.data(:,3));
%
% Check the range
%
if minlon<-170 && maxlon > 170
    %
    % Adjust event locations
    %
    for ii = 1 : length(matching.data(:,3))
        if matching.data(ii,3) < 0 
            matching_lon(ii) = matching.data(ii,3) + 360;
        else
            matching_lon(ii) = matching.data(ii,3);
        end
        if matching.data2(ii,3) < 0
            matching_lon2(ii) = matching.data2(ii,3)+360;
        else
            matching_lon2(ii) = matching.data2(ii,3);
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
    maxlat = max(matching.data(:,2)); 
    minlat = min(matching.data(:,2));
    midlat = (maxlat+minlat)/2;
    maxlon = max(matching_lon);
    minlon = min(matching_lon);
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
    h1 = plot(matching_lon,matching.data(:,2),'.','Color',[1 1 1]);
    h2 = plot(matching_lon,matching.data(:,2),'r.');
    h3 = plot(matching_lon2,matching.data2(:,2),'b.');
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
    legend([h1, h2, h3],['N=',num2str(size(matching.data,1))],cat1.name,cat2.name)
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
    h1 = plot(matching.data(:,3),matching.data(:,2),'.','Color',[1 1 1]);
    h2 = plot(matching.data(:,3),matching.data(:,2),'r.');
    h3 = plot(matching.data2(:,3),matching.data2(:,2),'b.');
    %
    % Restrict to Region of interest
    % Get minimum and maximum values for restricted axes
    %
    load('regions.mat')
    if strcmpi(reg,'all')
        poly(1,1) = min([cat1.data(:,3);cat2.data(:,3)]);
        poly(2,1) = max([cat1.data(:,3);cat2.data(:,3)]);
        poly(1,2) = min([cat1.data(:,2);cat2.data(:,2)]);
        poly(2,2) = max([cat1.data(:,2);cat2.data(:,2)]);
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
    legend([h1, h2, h3],['N=',num2str(size(matching.data,1))],cat1.name,cat2.name)
    box on
    hold off
    drawnow
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catdensplot(matching,reg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotmatchingrose(matching,cat1.name,cat2.name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Histograms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mn = min(matching.data(:,5))-0.05;
Mx = max(matching.data(:,5))+0.05;
step = 0.1;
bins = Mn:step:Mx;
%
% Magnitude Distribution
%
figure
hold on
histogram(matching.data(:,5),bins)
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
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Magnitude Comparison
%
p = polyfit(matching.data2(:,5),matching.data(:,5),1);
[P] = polyval(p,matching.data2(:,5));
R = corrcoef(P,matching.data(:,5));
R = R(1,2)^2;
figure
hold on
h1 = scatter(matching.data2(:,5),matching.data(:,5));
h2 = plot(matching.data2(:,5),P,'r-');
h3 = plot([0 9],[0 9],'k-');
%
% Bounds
%
Mins = min([min(matching.data2(:,5)),min(matching.data(:,5))]);
Maxs = max([max(matching.data2(:,5)),max(matching.data(:,5))]);
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
figure
hold on
histogram(matching.data(:,4))
%
% Figure formatting
%
ylabel('Counts','FontSize',15)
xlabel(['Depth (km) from ',cat1.name],'FontSize',15)
title('Depths for Matching Events','FontSize',15)
axis tight
box on
hold off
drawnow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Depth Comparison
%
p = polyfit(matching.data2(:,4),matching.data(:,4),1);
[P] = polyval(p,matching.data2(:,4));
R = corrcoef(P,matching.data(:,4));
R = R(1,2)^2;
figure
hold on
h1 = scatter(matching.data2(:,4),matching.data(:,4));
h2 = plot(matching.data2(:,4),P,'r-');
B = polyval([1 0],matching.data2(:,4));
h3 = plot(matching.data2(:,4),B,'k-');
%
% Bounds
%
Mins = min([min(matching.data2(:,4)),min(matching.data(:,4))]);
Maxs = max([max(matching.data2(:,4)),max(matching.data(:,4))]);
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
Time_convert = matching.data(:,9)*86400; %Seconds
min_delT = min(Time_convert)-1.5;
max_delT = max(Time_convert)+1.5;
step = 0.1;
bins = min_delT:step:max_delT;
figure
hold on
histogram(matching.data(:,9)*86400,bins)
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
min_delD = min(matching.data(:,6))-0.5;
max_delD = max(matching.data(:,6))+0.5;
step = 0.1;
bins = min_delD:step:max_delD;
figure
hold on
histogram(matching.data(:,6),bins)
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
figure
hold on
histogram(matching.data(:,8),[-1:0.1:1]);
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
min_delDp = min(matching.data(:,7))-0.5;
max_delDp = max(matching.data(:,7))+0.5;
step = 0.1;
bins = min_delDp:step:max_delDp;
figure
hold on
histogram(matching.data(:,7),bins)
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
