function dispyrcount(catalog,size)
% This function displays the event count per year of the catalog in list form. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

formatOut = 'yyyy';
time = datestr(catalog.data(:,1),formatOut);
time = str2num(time);
fulltime = horzcat(time,catalog.data(:,2:5));

M = length(fulltime);
begyear = fulltime(1,1);
endyear = fulltime(M,1);

s = struct([]);
count = 1;

for jj = begyear:endyear % Create structure divided by year
    
    ii = find(fulltime==jj);
    s(count).jj = fulltime(ii,:);
    count = count + 1; 
    
end

if length(size) > 3
    
    disp(['The total number of events per year:']);
    disp([' ']);
    for ii = 1:length(s)
        if length(s(ii).jj(:,1)) > 0
            disp([num2str(s(ii).jj(1,1)),' - ',num2str(length(s(ii).jj(:,1))),' events']);
        end
    end
    
% The rest below is a work in progress
%     disp([' ']);
%     disp(['The total number of events per year:']);
%     disp([' ']);
%     for ii = 1:length(s)
%         count = 0;
%         for ww = 1:length(s(ii).jj(:,1))   
%             if s(ii).jj(ww,5) == 'earthquake'
%                 count = count + 1;
%             end
%         end
%         disp([num2str(s(ii).jj(1,1)),' - ',num2str(count),' events']);
%     end
%     
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