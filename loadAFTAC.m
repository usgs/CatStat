function [cat] = loadAFTAC(pathname,catname)
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
    Tref = textscan(fid,'%s %s %f %f %f %f');
    fclose(fid);
    rawtime = strcat(Tref{1},{' '},Tref{2});
    time = datenum(rawtime,'mm/dd/yyyy HH:MM:SS.FFF');
    cat.data = sortrows(horzcat(time,Tref{3:4},Tref{6},Tref{5}),1);
    
cat.id = cell([length(cat.data(:,1)) 1]);
for i = 1:length(cat.data(:,1))
    cat.id{i,1} = 'id';
end

cat.evtype = cell([length(cat.data(:,1)) 1]);
for i = 1:length(cat.data(:,1))
    cat.evtype{i,1} = 'earthquake';
end
