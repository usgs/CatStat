function lrgcatevnts(catalog)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function lists the largest events in the catalog based on a user
% defined amount. Default is top 10.
% Input: Necessary components described
%         catalog.name   name of catalog
%         cat.data   data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type
% Output: None
%
% Written By: Matthew R Perry
% Last Edit: 07 November 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sort catalog data.
% 
largestnum = 10;
[nn,~] = sortrows(catalog.data,5);
nancount = sum(isnan(catalog.data.Mag) | catalog.data.Mag == -9.9);
%
disp(['The ',int2str(largestnum),' largest events within ', catalog.name])
disp(' ')
%
for ii = size(nn,1)-nancount:-1:size(nn,1)-(largestnum-1)-(nancount)
              disp([(datestr(nn.OriginTime(ii),'yyyy-mm-dd HH:MM:SS.FFF')),'  ',nn.ID{ii},' ',num2str(nn.Latitude(ii)),' ',num2str(nn.Longitude(ii)),' ',num2str(nn.Depth(ii)),' ',num2str(nn.Mag(ii))])
              disp(' ')
end
end
