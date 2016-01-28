function catmagyrcomp(yrmageqcsv,s)
% This function plots and compares the magnitude 5-year completeness. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

disp(['Magnitude distribution of earthquake events only. All other event types ignored.']);
disp([' ']);
disp(['The catalog has been broken up into 5 (or less) year chunks with the associated']);
disp(['cumulative completeness plotted. Lightest in color is the first 5 years of the catalog,']);
disp(['with shade increasing for each consecutive 5 year period. The last period may be less']);
disp(['than 5 years depending on total length of the catalog. Overall completeness for the']);
disp(['entire catalog remains in black at the top (with the total event count).']);

M = length(yrmageqcsv);
begyear = yrmageqcsv(1,1);
endyear = yrmageqcsv(M,1);

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
[yy,ii] = max(nn);
axis([minmag maxmag 10^0 10^6])
xlabel('Magnitude','fontsize',18)
ylabel('Number of Events','fontsize',18)
title('Cumulative Magnitude Distributions','fontsize',18)
legend('Overall Cumulative')
set(gca,'linewidth',1.5)
set(gca,'fontsize',15)
set(gca,'box','on')

hold on

mc = 1/((endyear-begyear)/30);
yy = 0;
ww = 5;


for yy = 0:5:((floor((endyear-begyear)/5))*5)
    
    if yy == ((floor((endyear-begyear)/5))*5)
        ww = ((endyear-begyear)+1);
    
    else
    timemag = [];
    for x = ((endyear-(endyear-yy))+1):(endyear-(endyear-ww))
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
    
    hh = semilogy(mags,cdf,'+','linewidth',1.5);
    set(hh,'Color',[mc mc mc]);
    %legend(endyear-yy)
    
    mc = mc - 1/(floor((endyear-begyear)/3));
    ww = ww + 5;
    end
    
end
