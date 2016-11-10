function [sizenum] = basiccatsum(catalog)
% This function provides basic catalog information and statistics
% Input: a structure containing catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   data table with ID, OriginTime, Latitude, Lonitude,
%                    Depth, Mag, and Type 
%         cat.auth   Authoritative Agency
% Output: 
%         sizenum    Integer that describes the temporal extend of the
%                    catalog. See internal function catalogsize for more
%                    information
%
% Written By: Matthew R. Perry
% Last Edit: 04 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Beginning and end dates of the catalog
%
[begdate, enddate] = findMinMax(catalog.data.OriginTime);
begdate = datestr(begdate,'yyyy-mm-dd HH:MM:SS.FFF');
enddate = datestr(enddate,'yyyy-mm-dd HH:MM:SS.FFF');
%
% Maximum and minimum event latitude, longitude, depth, and magnitude
%
[minlat, maxlat] = findMinMax(catalog.data.Latitude);
[minlon, maxlon] = findMinMax(catalog.data.Longitude);
[mindep, maxdep] = findMinMax(catalog.data.Depth);
[minmag, maxmag] = findMinMax(catalog.data.Mag);
%
% Get NaN and 0 magnitude and depth event totals
%
[Zero_Mag, NaN_Mag] = findZeroNaN(catalog.data.Mag);
[Zero_Dep, NaN_Dep] = findZeroNaN(catalog.data.Depth);
%
% Get unique events
%
U = unique(catalog.data.Type);
U_count = zeros(size(U,1),1);
for ii = 1 : size(U,1)
   U_count(ii) = sum(strcmpi(catalog.data.Type,U(ii)));
end
%
% Print Summary
%
fprintf(['Catalog Name:\t',catalog.name,'\n'])
fprintf(['File Name:\t',catalog.file,'\n'])
fprintf(['Date Generated:\t',datestr(datetime,'yyyy-mm-dd HH:MM:SS.FFF'),'\n'])
fprintf(['\n']);
fprintf(['First Date in Catalog:\t',begdate,'\n'])
fprintf(['Last Date in Catalog:\t',enddate,'\n'])
fprintf(['\n']);
fprintf(['Total Number of Events:\t',int2str(size(catalog.data,1)),'\n'])
if ~strcmpi('none',catalog.auth)
    if ~any(strcmp('authevnt',fields(catalog)))
        tt = length(catalog.auth);
        catalog.authevnt = sum(strncmpi(catalog.auth,catalog.data.ID,tt));
        catalog.nonauthevnt = sum(~strncmpi(catalog.auth,catalog.data.ID,tt));
    end
    fprintf(['Total Number of ', upper(catalog.auth),' Events:\t',int2str(catalog.authevnt),'\n'])
    fprintf(['Total Number of non-', upper(catalog.auth),' Events:\t',int2str(catalog.nonauthevnt),'\n'])
end
for ii = 1 : size(U,1)
   fprintf(['\t',U{ii},':\t',int2str(U_count(ii)),'\n'])
end
fprintf(['\n']);
fprintf(['Minimum Latitude:\t',num2str(minlat),'\n'])
fprintf(['Maximum Latitude:\t',num2str(maxlat),'\n'])
fprintf(['Minimum Longitude:\t',num2str(minlon),'\n'])
fprintf(['Maximum Longitude:\t',num2str(maxlon),'\n'])
fprintf(['\n']);
fprintf(['Minimum Depth:\t',num2str(mindep),'\n'])
fprintf(['Maximum Depth:\t',num2str(maxdep),'\n'])
fprintf(['Number of 0 km depth events:\t',num2str(Zero_Dep),'\n'])
fprintf(['Number of NaN depth events:\t',num2str(NaN_Dep),'\n'])
fprintf(['\n']);
fprintf(['Minimum Magnitude:\t',num2str(minmag),'\n'])
fprintf(['Maximum Magnitude:\t',num2str(maxmag),'\n'])
fprintf(['Number of 0 magnitude events:\t',num2str(Zero_Mag),'\n'])
fprintf(['Number of NaN magnitude events:\t',num2str(NaN_Mag),'\n'])
sizenum = catalogsize(catalog.data.OriginTime);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Internal Functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [min_data, max_data] = findMinMax(data)
        min_data = min(data);
        max_data = max(data);
    end

    function [ZERO_Data, NAN_Data] = findZeroNaN(data)
        NAN_Data = sum(isnan(data));
        ZERO_Data = sum(data==0);
    end

    function [sizenum] = catalogsize(data)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Find unique month and year combinations
        %
        dateV = datevec(data);    
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
    end     
%
% End of function
%
end
