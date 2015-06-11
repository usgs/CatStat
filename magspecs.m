function magspecs(yrmageqcsv,eqevents,catalog,sizenum)
% This function plots and compares the number of events of a specific magnitude. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

% Find events below increasing magnitude threshold and plot event count

disp(['Magnitude statistics and distribution of earthquake events throughout the catalog. All other event types ignored.']);

maxmag = ceil(max(yrmageqcsv(:,5)));
count = 1;
M = length(yrmageqcsv(:,1));
begyear = yrmageqcsv(1,1);
endyear = yrmageqcsv(M,1);

time = datestr(eqevents(:,1),'yyyy');
time = str2num(time);
yrmageqcsv = horzcat(time,eqevents(:,2:5)); % Converts time column to only years
yrmageqcsv(yrmageqcsv(:,5)==-9.9,5) = NaN; %Converts all -9.9 preferred mags to NaN
yrmageqcsv(isnan(yrmageqcsv(:,5)),:) = [];

for mm = 1:maxmag
    
    runyrmageqcsv = yrmageqcsv;
    index = find(runyrmageqcsv(:,5) >= mm);
    
    if size(index,1) > 0
    
        plotmag = runyrmageqcsv(index(:,1),:);
    
        subplot(maxmag,1,count)
        [nn,xx] = hist(plotmag(:,1),[begyear:1:endyear]);
        bar(xx,nn,'histc')
        ylabel(mm)
        set(gca,'linewidth',1.5)
        set(gca,'fontsize',12)
        hh = colorbar;
        set(hh,'visible','off');
    
        hold on
        count = count +1;
        
    else
        count = count;
    end
    
end

