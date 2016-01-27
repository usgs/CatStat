function [cat] = loadcat(cat)

% This function loads output from a ComCat Web search or feed in .CSV format
%
% Input: pathname       Path to directory with wanted catalog
%        catalogname    name of wanted catalog
%
% Output: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types

fid = fopen(cat.file, 'rt');

if(cat.format == 1); % ComCat format
  Tref = textscan(fid,'%s %f %f %f %f %s %s %s %s %s %s %s %s %q %s','HeaderLines',1,'Delimiter',','); %ComCat Online CSV Upload
  time = datenum(Tref{1},'yyyy-mm-ddTHH:MM:SS.FFF');
  [cat.data,ii] = sortrows(horzcat(time,Tref{2:5}),1);
  cat.id = Tref{12}(ii);
  cat.evtype = Tref{15}(ii);
elseif(cat.format == 2); % libcomcat format
  S = textscan(fid,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',','); 
  time = datenum(S{2},'yyyy-mm-dd HH:MM:SS.FFF');
  [cat.data,ii] = sortrows(horzcat(time,S{3:6}),1);
  cat.id = S{1}(ii);
  cat.evtype = S{7}(ii);
elseif(cat.format == 3) % OGS format
    S = textscan(fid,'%s %s %f %f %f %s %s %s %s %s %s %s %s %f %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',',');
    time = datenum(S{2},'yyyy-mm-dd HH:MM:SS');
    [cat.data,ii] = sortrows(horzcat(time,S{3:5},S{14}));
    cat.id = S{1}(ii);
    cat.evtype = S{15}(ii);
else
    disp('unknown catalog type')
end

fclose(fid);
