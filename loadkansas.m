function [cat] = loadkansas(pathname1,catname1)
% This function loads the Kansas Catalog
% Input: currently has no input and catalog name and path are hard coded
% Output: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 


cat.file = pathname1;
cat.name = catname1;
fid = fopen(cat.file, 'rt');
Tref = textscan(fid,'%f %f %f %f %f %f %f %f %f %f %s %f %f %f %f %s %f');
fclose(fid);

time = datenum(Tref{1:6});
[cat.data,ii] = sortrows(horzcat(time,Tref{7:10}),1);
cat.id = Tref{17}(ii);
cat.evtype = Tref{16}(ii);