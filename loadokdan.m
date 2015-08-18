function [cat] = loadokdan(pathname,catalogname)
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
S = textscan(fid,'%s %f %f %f %f %f %f %f %f','Delimiter',',');
fclose(fid);

time = datenum(S{1},'yyyy-mm-dd HH:MM:SS.FFF');

evtype = zeros(length(time),1);
evtype = num2cell(evtype);
for ii = 1:length(evtype)
    evtype{ii,1} = 'earthquake';
end

id = zeros(length(time),1);
id = num2cell(id);
for ii = 1:length(id)
    id{ii,1} = 'OK';
end

[cat.data,ii] = sortrows(horzcat(time,S{2:5}),1);
cat.id = id(ii);
cat.evtype = evtype(ii);

