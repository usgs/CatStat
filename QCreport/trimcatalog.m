function [cat] = trimcatalog(cat)
%
% Function that will apply a regional and authoritative event filter 
% to the catalog data.  If region 'all' or authoritative agency 'none' 
% are selected, no filtering will be applied.
%
% Inputs -
%   cat - catalog data structure must contain cat.data (from loadcat),
%   cat.reg, and cat.auth (both from mkQCreport).
%   cat.reg - Regional filter
%   cat.auth - Authoritative agency filter
%
%
% Outouts - 
%   cat - filtered catalog data structure; see loadcat for more information
%
% Written By: Matthew R. Perry
% Last Edit: 04 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Begin Function
%
% Restrict catalog to region of interest
%
if ~strcmpi('all',cat.reg);
    load('regions.mat')
    ind = find(strcmpi(region, cat.reg));
    poly = coord{ind,1};
    ind1 = inpolygon(cat.data.Longitude,cat.data.Latitude,poly(:,1), poly(:,2));
    cat.data = cat.data(ind1,:);
end
%
% Remove non-authoritative events
%
if ~strcmpi('none',cat.auth)
    tt = length(cat.auth);
    ind2 = find(strncmpi(cat.auth,cat.data.ID,tt));
    cat.authevnt = length(ind2);
    cat.nonauthevnt = size(cat.data,1) - cat.authevnt;
    cat.data = cat.data(ind2,:);
end
%
% End of function
%
end