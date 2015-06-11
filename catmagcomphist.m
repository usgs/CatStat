function [compmag] = catmagcomphist(eqevents,catalog,yrmageqcsv,s)
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

M = length(yrmageqcsv);
begyear = yrmageqcsv(1,1);
endyear = yrmageqcsv(M,1);

timemag = [];

for x = 1:((endyear-begyear)+1)
    
    row = horzcat(s(x).jj(:,1),s(x).jj(:,5));
    timemag = [timemag;row];
    
end

compmag = timemag(:,2);

%sortcompmag = sortrows(compmag(:,1),1);
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

figure('Color',[1 1 1]);
subplot(2,1,1)
hist2d(datenum(eqevents(:,1)),eqevents(:,5),min(datenum(eqevents(:,1))):365:max(datenum(eqevents(:,1))),0:0.5:maxmag);
%ax = gca;
%ax.XTick = (catalog.data(1,1):(365*12):catalog.data(M,1));
datetick('x','yyyy','keepticks')
colormap([[0.9,0.9,0.9];jet(max(nn(:)))])
set(gca,'ydir','normal')
colorbar
hold on
ylabel('Magnitude','fontsize',18)
set(gca,'fontsize',10)
set(gca,'box','on')
axis([min(datenum(eqevents(:,1))) max(datenum(eqevents(:,1))) 0 maxmag])

subplot(2,1,2)
[nn,xx] = hist(yrmageqcsv(:,1),[begyear:1:endyear]);
bar(xx,nn,'histc')
xlabel('Year','fontsize',18)
ylabel('Number of Events','fontsize',18)
set(gca,'linewidth',1.5)
set(gca,'fontsize',10)
ax = axis;
axis([begyear endyear+1 0 max(nn)*1.1])
hh = colorbar;
set(hh,'visible','off');

hold off
