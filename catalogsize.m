function [sizenum] = catalogsize(catalog)
% This function plots and compares event frequency over the entire catalog. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: None

% formatOut = 'yyyy';
% time = datestr(catalog.data(:,1),formatOut);
% time = str2num(time);
% 
% M = length(time);
% begyear = time(1,1);
% endyear = time(M,1);
% 
% size = struct([]);
% count = 1;
% 
% for jj = begyear:endyear % Create structure divided by year
%     
%     ii = find(time==jj);
%     size(count).jj = time(ii,:);
%     count = count + 1; 
%     
% end
% 
dateV = datevec(catalog.data(:,1));    
check = unique(dateV(:,1:2),'rows'); % finds unique month and year combinations

if length(check) > 5 % If there are more than 5 unique month and year combinations
    check = unique(dateV(:,1),'rows'); % Check how many years are present
    if length(check) > 3
        sizenum = 1; % If more than 5 year month combinations and more than 3 years, then use yearly plotting
    else
        sizenum = 2; % If more than 5 year month combinations but less than 3 years, then use monthly plotting
    end
else
    sizenum = 3; % If less than 5 year month combinations, then use daily plotting
end
    
    
    
    