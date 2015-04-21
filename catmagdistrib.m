function [yrmagcsv,s] = catmagdistrib(sortcsv)
% This function plots and compares the distribution of magnitude. 
% Input: Sorted catalog matrix
% Output: None

disp(['In this section we look at various magnitude statistics for the specified ']);
disp(['catalog: ']);
disp(['(a) and the median magnitude for each year (b) showing the general ']);
disp(['trend through time.']);
disp([' ']);

maxmag = max(sortcsv(:,5));
minmag = min(sortcsv(:,5));
zerocount = sum(sortcsv(:,5) == 0);
nancount = sum(isnan(sortcsv(:,5)) | sortcsv(:,5) == -9.9);

disp(['Minimum Magnitude: ',num2str(minmag)])
disp(['Maximum Magnitude: ',num2str(maxmag)])
disp([' ']);
disp(['Number of Events with Zero Magnitude: ',int2str(zerocount)])
disp(['Number of Events without a Magnitude: ',int2str(nancount)])
disp([' ']);

% Magnitude Year Specific Statistics

formatOut = 'yyyy';
time = datestr(sortcsv(:,1),formatOut);
time = str2num(time);
yrmagcsv = sortcsv;
yrmagcsv(:,1) = time(:,1); % Converts time column to only years

yrmagcsv(yrmagcsv(:,5)==-9.9,5) = NaN; %Converts all -9.9 preferred mags to NaN
% allmagcsv(allmagcsv(:,5)==0,5) = NaN; %Converts all 0 preferred mags to NaN
yrmagcsv(isnan(yrmagcsv(:,5)),:) = []; %Removes all rows with NaN for preferred mag

disp(['a. Plot of magnitudes over the span of the catalog - demonstrates gaps ']);
disp(['in the catalog that have 0 or NaN for the preferred magnitude.']);
disp([' ']);

figure
plot(datenum(sortcsv(:,1)),sortcsv(:,5),'.');
datetick
set(gca,'fontsize',15)
title('a. All Magnitudes Through Catalog','fontsize',18);
ylabel('Magnitude','fontsize',18);

M = length(yrmagcsv);
begyear = yrmagcsv(1,1);
endyear = yrmagcsv(M,1);
s = struct([]);
count = 1;

for jj = begyear:endyear % Create structure divided by year
    
    ii = find(yrmagcsv==jj);
    s(count).jj = yrmagcsv(ii,:);
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

