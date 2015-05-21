function [size] = catalogsize(catalog)
% This function plots and compares event frequency over the entire catalog. 
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

M = length(time);
begyear = time(1,1);
endyear = time(M,1);

size = struct([]);
count = 1;

for jj = begyear:endyear % Create structure divided by year
    
    ii = find(time==jj);
    size(count).jj = time(ii,:);
    count = count + 1; 
    
end