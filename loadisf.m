function [cat] = loadisf(pathname,catname)
% This function loads the two catalogs that will be compared based on their
% format. This upload format must be changed based on the catalog type.
% Input: currently has no input and catalog name and path are hard coded -
% the upload format is also hardcoded based on the catalog file type
% Output: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types  


cat.file = pathname;
cat.name = catname;
fid = fopen(cat.file, 'rt');
Tref = textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %s','Delimiter',',');
fclose(fid);

time = datenum(Tref{1:6});
[cat.data,ii] = sortrows(horzcat(time,Tref{7:14}),1);
cat.id = Tref{15}(ii);
cat.evtype = Tref{15}(ii);
