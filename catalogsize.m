function [sizenum] = catalogsize(catalog)
% This function determine if plots should be made by year or month or day
% based on catalog size.
%
% Input: a structure containing catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% Output: sizenum    1 -- If more than 5 year month combinations and more
%                         than 3 years, then use yearly plotting.
%                    2 -- If more than 5 year month combinations but 
%                         less than 3 years, then use monthly plotting.
%                    3 -- If less than 5 year month combinations, then 
%                         use daily plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Find unique month and year combinations
%
dateV = datevec(catalog.data(:,1));    
check = unique(dateV(:,1:2),'rows');
%
% If there are more than 5 unique month and year combinations
%
if length(check) > 5
    %
    % Check how many years are present
    %
    check = unique(dateV(:,1),'rows');
    if length(check) > 3
        %
        % If more than 5 year month combinations and more than 3 years, 
        % then use yearly plotting
        %
        sizenum = 1;
    else
        %
        % If more than 5 year month combinations but less than 3 years, 
        % then use monthly plotting
        %
        sizenum = 2;
    end
else
    %
    % If less than 5 year month combinations, then use daily plotting
    %
    sizenum = 3; 
end
%
% End of function
%
    
    
    