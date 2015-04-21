function [cat] = loadlibcomcat(pathname,catalogname)
% This function loads output from Mike Hearne's libcomcat program
% Input: currently has no input and catalog name and path are hard coded
% Output: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types  


cat.file = pathname;
cat.name = catalogname;
fid = fopen(cat.file, 'rt');
S = textscan(fid,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',',');
fclose(fid);

time = datenum(S{2},'yyyy-mm-dd HH:MM:SS.FFF');
[cat.data,ii] = sortrows(horzcat(time,S{3:6}),1);
cat.id = S{1}(ii);
cat.evtype = S{7}(ii);
