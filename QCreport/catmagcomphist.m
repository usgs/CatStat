function [] = catmagcomphist(EQEvents)
% This function plots and compares the magnitude completeness. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

disp(['Median magnitude distribution of earthquake events only. All other event types ignored.']);

% Magnitude color plot
disp(['The final plot is a colorized histogram plot of magnitude for each']);
disp(['year of the catalog, showing how the completeness changes through ']);
disp(['time. It is shown with the corresponding event count through time.']);
disp([' ']);

begyear = str2double(datestr(min(EQEvents.OriginTime),'yyyy'));
endyear = str2double(datestr(max(EQEvents.OriginTime),'yyyy'));
minmag = floor(min(EQEvents.Mag));
maxmag = ceil(max(EQEvents.Mag));
[nn,~] = hist(EQEvents.Mag,minmag:0.1:maxmag);
figure('Color',[1 1 1]);
subplot(2,1,1)
hist2d(datenum(EQEvents.OriginTime),EQEvents.Mag,min(datenum(EQEvents.OriginTime)):365:max(datenum(EQEvents.OriginTime)),0:0.5:maxmag);
datetick('x','yyyy','keepticks')
colormap([[0.9,0.9,0.9];jet(max(nn(:)))])
set(gca,'ydir','normal')
colorbar
hold on
ylabel('Magnitude','fontsize',18)
set(gca,'fontsize',10)
set(gca,'box','on')
axis([min(datenum(EQEvents.OriginTime)) max(datenum(EQEvents.OriginTime)) 0 maxmag])
%
%
%
Years = str2num(datestr(EQEvents.OriginTime,'yyyy'));
subplot(2,1,2)
[nn,xx] = hist(Years,begyear:1:endyear);
bar(xx,nn,'histc')
xlabel('Year','fontsize',18)
ylabel('Number of Events','fontsize',18)
set(gca,'linewidth',1.5)
set(gca,'fontsize',10)
axis([begyear endyear+1 0 max(nn)*1.1])
hh = colorbar;
set(hh,'visible','off');

hold off
