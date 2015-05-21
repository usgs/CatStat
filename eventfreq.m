function eventfreq(catalog,size)
% This function plots and compares event frequency over the entire catalog. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

figure
%[nn,xx]= hist(catalog.data(:,1),catalog.data(1,1):1:catalog.data(M,1));
hist(catalog.data(:,1),catalog.data(1,1)-0.5:1:max(catalog.data(:,1))-0.5)
set(gca,'fontsize',15)
title('Events per Day','fontsize',18)
ylabel('Number of Events','fontsize',18)
if length(size) > 3
    datetick
    xlabel('Years','fontsize',18)
elseif length(size) == 1
    datetick('x','mm-dd-yy')
    ylabel('Month-Day-Year','fontsize',18)
else
    datetick('x','mmmyy')
    ylabel('Month-Year','fontsize',18)
end
axis tight;
ax = axis;
axis([ax(1:2) 0 ax(4)*1.1])

% Displaying Event Count per year

formatOut = 'yyyy';
time = datestr(catalog.data(:,1),formatOut);
time = str2num(time);

M = length(time);
begyear = time(1,1);
endyear = time(M,1);

s = struct([]);
count = 1;

for jj = begyear:endyear % Create structure divided by year
    
    ii = find(time==jj);
    s(count).jj = time(ii,:);
    count = count + 1; 
    
end

if length(size) > 3
    
    disp(['The total number of events per year:']);
    disp([' ']);
    for ii = 1:length(s)
       disp([num2str(s(ii).jj(1,1)),' - ',num2str(length(s(ii).jj(:,1))),' events']);
    end
    
% elseif length(size) == 1
%     
%     disp(['The total number of events per day:']);
%     disp([' ']);
%     for ii = 1:length(s)
%        disp([num2str(s(ii).jj(1,1)),' - ',num2str(length(s(ii).jj(:,1))),' events']);
%     end
%     
% else
%     
%     disp(['The total number of events per month:']);
%     disp([' ']);
%     for ii = 1:length(s)
%        disp([num2str(s(ii).jj(1,1)),' - ',num2str(length(s(ii).jj(:,1))),' events']);
%     end 

end