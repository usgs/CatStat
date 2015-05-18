function [cat1] = loadNepal(pathname1,catname1)
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


cat1.file = pathname1;
cat1.name = catname1;
fid = fopen(cat1.file, 'rt');
T = textscan(fid,'%s %f %f %f %f %s %s','Delimiter',','); %NSC Format Upload
fclose(fid);

time = datenum(T{1},'yyyy/mm/dd HH:MM');
[cat1.data,ii] = sortrows(horzcat(time,T{2:5}),1);
cat1.id = T{6}(ii);
cat1.evtype = T{7}(ii);
