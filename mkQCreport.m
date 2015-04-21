%% Catalog Information

clear
close all

% Load Catalog
catalog = loadlibcomcat();


%% Basic Catalog Summary
sortcsv = catalog.data;
id = catalog.id;
evtype = catalog.evtype;
filename = catalog.name;

begdate = datestr(sortcsv(1,1),'yyyy-mm-dd HH:MM:SS.FFF');
enddate = datestr(sortcsv(length(sortcsv),1),'yyyy-mm-dd HH:MM:SS.FFF');

M = length(sortcsv);

maxlat = max(sortcsv(:,2));     
minlat = min(sortcsv(:,2));     
maxlon = max(sortcsv(:,3));     
minlon = min(sortcsv(:,3));
maxdep = max(sortcsv(:,4));
mindep = min(sortcsv(:,4)); 
nandepcount = sum(isnan(sortcsv(:,4)));
maxmag = max(sortcsv(:,5));
minmag = min(sortcsv(:,5));
zerocount = sum(sortcsv(:,5) == 0);
nancount = sum(isnan(sortcsv(:,5)) | sortcsv(:,5) == -9.9);

disp(['Catalog Name: ',filename])
disp([' ']);
disp(['First Date in Catalog: ',begdate])
disp(['Last Date in Catalog: ',enddate])
disp([' ']);
disp(['Total Number of Events: ',int2str(length(sortcsv))])
disp([' ']);
disp(['Minimum Latitude: ',num2str(minlat)])
disp(['Maximum Latitude: ',num2str(maxlat)])
disp([' ']);
disp(['Minimum Longitude: ',num2str(minlon)])
disp(['Maximum Longitude: ',num2str(maxlon)])
disp([' ']);
disp(['Minimum Depth: ',num2str(mindep)])
disp(['Maximum Depth: ',num2str(maxdep)])
disp([' ']);
disp(['Minimum Magnitude: ',num2str(minmag)])
disp(['Maximum Magnitude: ',num2str(maxmag)])
disp([' ']);
disp(char(['Event types: ',unique(evtype)']))

%% Seismicity Map

%maplonmin = minlon - 5;
maplonmin = max(minlon-5,-180);
maplonmax = maxlon + 5;
maplatmin = minlat - 5;
maplatmax = maxlat + 5;

% if minlon < -174
%     maplonmin = -180;
% end

if maxlon > 174
    maplonmax = 180;
end

if minlat > -85 && minlat < 0
    maplatmin = -90;
end

if maxlat > 85 && maxlat > 0
    maplatmax = 90;
end

% plot quakes
plot(sortcsv(:,3),sortcsv(:,2),'r.')
daspect([1,1,1]);
set(gca,'fontsize',15)
axis([maplonmin maplonmax maplatmin maplatmax]);
hold on

% load, process, and plot coastline data
load ./Data/coastline.data
coastline(coastline == 99999) = NaN;
clat = coastline(:,2);
clon = coastline(:,1);
clon(abs(diff(clon))>180) = NaN;
plot(clon,clat,'k','linewidth',1)
xlabel('Longitude');
ylabel('Latitude');
hold on

rectangle('Position',[minlon minlat abs(abs(maxlon)-abs(minlon)) abs(abs(maxlat)-abs(minlat))])

%% Depth Distribution

disp(['Minimum Depth: ',int2str(mindep)])
disp(['Maximum Depth: ',int2str(maxdep)])
disp(['Number of Events without a Depth: ',int2str(nandepcount)])

figure
sortcsv(sortcsv(:,4)==-999,4) = NaN;
%[nn,xx] = hist(sortcsv(:,4),ceil(mindep):1:maxdep);
hist(sortcsv(:,4),(mindep+0.5):(maxdep-0.5))

axis tight;
ax = axis;
axis([mindep maxdep 0 ax(4)*1.1])
set(gca,'fontsize',15)
title('Depth Histogram','fontsize',18)
xlabel('Depth [km]','fontsize',18)
ylabel('Number of Events','fontsize',18)

%% Event Frequency

disp(['The frequency of events within the catalog is analyzed by looking at the ']);
disp(['number of events per day (a) and the number of events throughout the day (b).']);
disp([' ']);
disp(['a. This first plot shows the number of events that occur throughout']);
disp(['the span of the catalog, providing a number count for each day.']);
disp([' ']);

figure
%[nn,xx]= hist(sortcsv(:,1),sortcsv(1,1):1:sortcsv(M,1));
hist(sortcsv(:,1),sortcsv(1,1)-0.5:1:max(sortcsv(:,1))-0.5)
datetick
set(gca,'fontsize',15)
title('Events per Day','fontsize',18)
ylabel('Number of Events','fontsize',18)
xlabel('Years','fontsize',18)
axis tight;
ax = axis;
axis([ax(1:2) 0 ax(4)*1.1])

% Event Frequency - Day vs. Night

disp(['b. Comparison of event activity to hours throughout the day may indicate ']);
disp(['the degree of anthropogenic influence - such as mining blasts - in the']);
disp(['catalog. Or increased human activity could reduce ability to register ']);
disp(['earthquake activity.']);
%disp(['Vertical lines indicate typical sunrise/sunset hours (daytime).']);
disp([' ']);

% fid = fopen(filename, 'rt');
% S = textscan(fid,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',',');
% fclose(fid);
% formatIn = 'yyyy-mm-dd HH:MM:SS';
% id = S{1};
% datetime = datenum(S{2},formatIn);
% formatOut = 'HH';
% time = datestr(datetime,formatOut);
% hour = str2num(time);
% lat = S{3};
% lon = S{4};
% dep = S{5};
% mag = S{6};
% type = S{7};
% allhours = horzcat(hour, lat, lon, dep, mag);

% PSTOT = sortcsv(:,1) - (8/24); % For California Only - Change to Pacific Standard Time
% formatOut = 'HH';
% time = datestr(PSTOT,formatOut);
% hour = str2num(time);

% find hour of the day in Pacific Standard Time (GMT -8)
hour = mod(sortcsv(:,1)*24-8,24);

figure
% [nn,xx] = hist(hour,0.5:23.5);
hist(hour,0.5:23.5);
xlabel('Hour of the Day (Pacific Standard Time UTC-8)','fontsize',18)
ylabel('Number of Events','fontsize',18)
title('Events per Hour of the Day','fontsize',18)
set(gca,'linewidth',1.5)
set(gca,'fontsize',15)

axis tight;
ax = axis;
axis([ax(1:2),0,ax(4)*1.1])
%hhh=vline(7,'k');
%hhh=vline(14,'k');
hold off

%% Inter-Event Temporal Spacing

disp(['The amount of time that passes between individual events can further']);
disp(['indicate how frequently events are occurring. Large time separations could']);
disp(['demonstrate gaps in the catalog. The median and maximum time separation ']);
disp(['for each year is also graphed to show the general trend in event frequency.']);
disp([' ']);

M = length(sortcsv);
timesep = [];

timesep = diff(sortcsv,1);
datetimesep = horzcat(sortcsv(1:(M-1),1),timesep(:,1));

sorttime = sortrows(timesep,1);
mediansep = median(sorttime(:,1));
maxsep = sorttime(M-1,1);

disp(['The Median Time Between Events: ',num2str(mediansep)])
disp(['The Maximum Time Between Events: ',num2str(maxsep)])

subplot(3,1,1)
plot(datetimesep(:,1),datetimesep(:,2))
datetick
set(gca,'fontsize',15)
title('Time Separation Between Events','fontsize',18)
xlabel('Year','fontsize',18);
ax = axis;
axis([datetimesep(1,1) datetimesep(length(datetimesep),1) 0 max(datetimesep(:,2))*1.1])

% Time Separation Year Specific Statistics

timedif = diff(sortcsv(:,1));
dateV = datevec(sortcsv(:,1));
years = dateV(:,1);
years(1) = []; % make years same size as difference vector
XX = min(years):max(years);

for ii = 1:length(XX)
    maxsepyr(ii) = max(timedif(years == XX(ii)));
    medsepyr(ii) = median(timedif(years == XX(ii)));
end

subplot(3,1,2)
bar(XX,maxsepyr,1)
set(gca,'fontsize',15)
title('Maximum Event Separation by Year','fontsize',18)
ylabel('Length of Time Separation (Days)','fontsize',18)
xlabel('Year','fontsize',18);
axis tight;
ax = axis;
axis([ax(1:2), 0 ax(4)*1.1])

subplot(3,1,3)
bar(XX,medsepyr,1)
set(gca,'fontsize',15)
title('Median Event Separation by Year','fontsize',18)
xlabel('Year','fontsize',18);
axis tight;
ax = axis;
axis([ax(1:2), 0 ax(4)*1.1])

%% Magnitude Distribution: Through Time

disp(['In this section we look at various magnitude statistics for the specified ']);
disp(['catalog: ']);
disp(['(a) and the median magnitude for each year (b) showing the general ']);
disp(['trend through time.']);
disp([' ']);

disp(['Minimum Magnitude: ',num2str(minmag)])
disp(['Maximum Magnitude: ',num2str(maxmag)])
disp([' ']);
disp(['Number of Events with Zero Magnitude: ',int2str(zerocount)])
disp(['Number of Events without a Magnitude: ',int2str(nancount)])
disp([' ']);

% Magnitude Year Specific Statistics

fid = fopen('../Data/ci_1900.csv', 'rt');
S = textscan(fid,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',',');
fclose(fid);
formatIn = 'yyyy-mm-dd HH:MM:SS.FFF';
id = S{1};
datetime = datenum(S{2},formatIn);
formatOut = 'yyyy';
time = datestr(datetime,formatOut);
time = str2num(time);
lat = S{3};
lon = S{4};
dep = S{5};
mag = S{6};
type = S{7};
allmagcsv = horzcat(time, lat, lon, dep, mag);

allmagcsv(allmagcsv(:,5)==-9.9,5) = NaN; %Converts all -9.9 preferred mags to NaN
allmagcsv(allmagcsv(:,5)==0,5) = NaN; %Converts all 0 preferred mags to NaN
allmagcsv(isnan(allmagcsv(:,5)),:) = []; %Removes all rows with NaN for preferred mag

disp(['a. Plot of magnitudes over the span of the catalog - demonstrates gaps ']);
disp(['in the catalog that have 0 or NaN for the preferred magnitude.']);
disp([' ']);

figure
plot(datenum(sortcsv(:,1)),sortcsv(:,5),'.');
datetick
set(gca,'fontsize',15)
title('a. All Magnitudes Through Catalog','fontsize',18);
ylabel('Magnitude','fontsize',18);

M = length(allmagcsv);

begyear = allmagcsv(1,1);
endyear = allmagcsv(M,1);
s = struct([]);
count = 1;

for jj = begyear:endyear % Create structure divided by year
    
    ii = find(allmagcsv==jj);
    s(count).jj = allmagcsv(ii,:);
    count = count + 1; 
    
end

count = 1;
newmedians = []; 

for yy = begyear:endyear % Create median file
    
    medrow = [yy,median(s(count).jj(:,5))];
    newmedians = [newmedians;medrow];
    count = count + 1;
    
end

disp(['b. Plot of the median magnitude (an approximate gauge for completeness)']);
disp(['through the time of the catalog.']);
disp([' ']);

figure
bar(newmedians(:,1),newmedians(:,2))
set(gca,'fontsize',15)
title('b. Yearly Median Magnitude','fontsize',18);
ylabel('Magnitude','fontsize',18);
xlabel('Year','fontsize',18);
axis tight

%% Magnitude Distribution: Completeness

disp(['While the median magnitude can give an approximate look at magnitude ']);
disp(['distributions (cumulative and incremental) provide further indicators of ']);
disp(['catalog completeness.']);
disp([' ']);

timemag = [];

for x = 1:((endyear-begyear)+1)
    
    row = horzcat(s(x).jj(:,1),s(x).jj(:,5));
    timemag = [timemag;row];
    
end

compmag = timemag(:,2);

sortcompmag = sortrows(compmag(:,1),1);
L = length(compmag(:,1));

minmag = floor(min(compmag(:,1)));
maxmag = ceil(max(compmag(:,1)));
[nn,xx] = hist(compmag(:,1),[minmag:0.1:maxmag]);

% Calculate cumulative magnitude distribution
cdf =[];
idf =[];
jj = 0;
mags = [minmag:0.1:maxmag];

for cmag = mags 
    
  jj = jj+1;
  cdf(jj) = sum(round(compmag(:,1)*10)>=round(cmag*10));
  idf(jj) = sum(round(compmag(:,1)*10)==round(cmag));
  
end

figure
hh = semilogy(mags,cdf,'k+','linewidth',1.5);
hold on
hh = semilogy(xx,nn,'ro','linewidth',1.5);
[yy,ii] = max(nn);
estcomp = mags(ii);
disp(['Estimated Completeness (max incremental): ',num2str(estcomp)]);
disp([' ']);
axis([minmag maxmag 10^0 10^6])
legend('Cumulative','Incremental')
xlabel('Magnitude','fontsize',18)
ylabel('Number of Events','fontsize',18)
title('Magnitude Distributions','fontsize',18)
set(gca,'linewidth',1.5)
set(gca,'fontsize',15)
set(gca,'box','on')

% Magnitude color plot
disp(['The final plot is a colorized histogram plot of magnitude for each year ']);
disp(['of the catalog, showing how the completeness changes ']);
disp(['through time. It is shown with the corresponding event count through time.']);
disp([' ']);

figure('Color',[1 1 1]);
subplot(2,1,1)
hist2d(datenum(sortcsv(:,1)),sortcsv(:,5),min(datenum(sortcsv(:,1))):365:max(datenum(sortcsv(:,1))),0:0.5:maxmag);
datetick
colormap([[0.9,0.9,0.9];jet(max(nn(:)))])
set(gca,'ydir','normal')
colorbar
hold on
ylabel('Magnitude','fontsize',18)
set(gca,'fontsize',10)
set(gca,'box','on')
axis([min(datenum(sortcsv(:,1))) max(datenum(sortcsv(:,1))) 0 maxmag])

subplot(2,1,2)
minyr = begyear;
maxyr = endyear;
[nn,xx] = hist(allmagcsv(:,1),[minyr:1:maxyr]);
hist(allmagcsv(:,1),[minyr:1:maxyr]);
xlabel('Year','fontsize',18)
ylabel('Number of Events','fontsize',18)
set(gca,'linewidth',1.5)
set(gca,'fontsize',10)
ax = axis;
axis([minyr maxyr+1 0 max(nn)*1.1])
hh = colorbar;
set(hh,'visible','off');
%set(gca,'xtick',x(1973):10:x(2015));

hold off


%% Searching for Duplicate Events

% Calculate Number of Events within X seconds and Z km
% This plot is to help pick thresholds to look for duplicate events. It
% shows the number of events within a given time and distance
% separation. It is an estimate because it just compares events adjacent in
% time. It does not compare each event to every other event in the catalog.

nquakes = length(sortcsv);
tdifsec = abs(diff(sortcsv(:,1)))*24*60*60;
ddelkm = distance(sortcsv(1:(nquakes-1),2:3),sortcsv(2:nquakes,2:3))*111.12;

nn = []; xx = [];
kmLimits = [1,2,4,8,16,32,64,128];
tmax = 5;
dt = 0.05;

for jj = 1:length(kmLimits)
   [nn(jj,:),xx(jj,:)] = hist(tdifsec(ddelkm<kmLimits(jj) & tdifsec < (tmax+dt/2)),[dt/2:dt:(tmax-dt/2)]);
end

totMatch = cumsum(nn');
figure
plot(xx(1,:)+dt/2,totMatch)
hold on
%plot(xx(1,:)+0.5,totMatch,'o')
title('Cumulative number of events withing X seconds and Z km (Z specified in legend)')
xlabel('Seconds')
ylabel('Total Number of Events')

%% Possible Duplicate Events

secondsMax = 1;
kmMax = 1;
disp(['List of event pairs within ', num2str(secondsMax),' seconds and ', num2str(kmMax) ' kilometers'] )
disp(' ')
dup = 0;
for ii = 2:length(sortcsv)
       if(abs(sortcsv(ii,1)-sortcsv(ii-1,1)) <= secondsMax/24/60/60)
           if(distance(sortcsv(ii,2:3),sortcsv(ii-1,2:3)) <= kmMax/111.12)
              disp([datestr(sortcsv(ii-1,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',char(id(ii-1)),' ',num2str(sortcsv(ii-1,2:5))])
              disp([datestr(sortcsv(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',char(id(ii)),' ',num2str(sortcsv(ii,2:5))])
              disp('-----------------------')
              dup = dup+1;
           end
       end
end
disp(['Finished looking for possible duplicate events in: ', filename] )
disp(['Possible Duplicates: ',int2str(dup),' events within ', num2str(secondsMax),' seconds and ', num2str(kmMax) ' kilometers'])

