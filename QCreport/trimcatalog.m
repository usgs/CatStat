function cat = trimcatalog(cat,reg)
%
% Function that will apply a regional filter to the catalog data.  If
% region 'all' is selected, no filtering will be applied.
%
% Inputs -
%   cat - catalog data structure
%   reg - authoritative region filter
%
% Outouts - 
%   cat - filtered catalog data structure
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Begin Function
%
% Restrict catalog to region of interest
%
load('regions.mat')
ind = find(strcmpi(region, reg));
poly = coord{ind,1};
ind1 = inpolygon(cat.data.Longitude,cat.data.Latitude,poly(:,1), poly(:,2));
cat.data = cat.data(ind1,:);
%
% End of function
%
end