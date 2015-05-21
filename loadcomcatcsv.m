function [cat] = loadcomcatcsv(pathname1,catname1)
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


cat.file = pathname1;
cat.name = catname1;
fid = fopen(cat.file, 'rt');
Tref = textscan(fid,'%s %f %f %f %f %s %s %f %f %f %s %s %s %s %s %s','HeaderLines',1,'Delimiter',','); %ComCat Online CSV Upload
fclose(fid);

time = datenum(Tref{1},'yyyy-mm-dd HH:MM:SS.FFF');
[cat.data,ii] = sortrows(horzcat(time,Tref{2:5}),1);
cat.id = Tref{12}(ii);
cat.evtype = Tref{16}(ii);
