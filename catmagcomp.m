function catmagcomp(sortcsv,yrmagcsv,s)
% This function plots and compares the magnitude completeness. 
% Input: Sorted catalog matrix
% Output: None

disp(['While the median magnitude can give an approximate look at magnitude ']);
disp(['distributions (cumulative and incremental) provide further indicators of ']);
disp(['catalog completeness.']);
disp([' ']);

M = length(yrmagcsv);
begyear = yrmagcsv(1,1);
endyear = yrmagcsv(M,1);

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
[nn,xx] = hist(yrmagcsv(:,1),[minyr:1:maxyr]);
hist(yrmagcsv(:,1),[minyr:1:maxyr]);
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

