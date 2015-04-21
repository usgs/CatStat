function [cat] = loadlibcomcat(pathname,catalogname)
% This function loads output from Mike Hearne's libcomcat program
% Input: currently has no input and catalog name and path are hard coded
% Output: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of 
%   origin-time, lat, lon, depth, pmag, mb, ms, mag1, mag2 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types  


cat.file = pathname;
cat.name = catalogname;
fid = fopen(cat.file, 'rt');
%2011,07,31,23,38,56.61,-3.518,144.828,10,6.6,6.2,6.6,6.6,6.6,earthquake,P
S = textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %s %s','HeaderLines',1,'Delimiter',',');
fclose(fid);

time = datenum(horzcat(S{:,1:6}));
[cat.data,ii] = sortrows(horzcat(time,S{7:14}),1);
cat.id = S{16}(ii);
cat.evtype = S{15}(ii);
