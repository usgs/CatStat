function [cat] = loadcat(cat)
% This function loads output from a ComCat Web search or feed in .CSV format
%
% Input: cat- information from initMkQCreport.dat file.  Read by mkQCreport 
%
% Output: Structure of catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Open file for reading
%
fid = fopen(cat.file, 'rt');
%
% ComCat format
%
if(cat.format == 1);
  Tref = textscan(fid,'%s %f %f %f %f %s %s %s %s %s %s %s %s %q %s %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',','); %ComCat Online CSV Upload
  time = datenum(Tref{1},'yyyy-mm-ddTHH:MM:SS.FFF');
  [cat.data,ii] = sortrows(horzcat(time,Tref{2:5}),1);
  cat.id = Tref{12}(ii);
  cat.evtype = Tref{15}(ii);
%
% libcomcat format
%
elseif(cat.format == 2); % libcomcat format
  S = textscan(fid,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',','); 
  time = datenum(S{2},'yyyy-mm-dd HH:MM:SS.FFF');
  [cat.data,ii] = sortrows(horzcat(time,S{3:6}),1);
  cat.id = S{1}(ii);
  cat.evtype = S{7}(ii);
%
% OGS format S{14} is the preferred mag, S{17} is auto Ml
%
elseif(cat.format == 3) % OGS format
    S = textscan(fid,'%s %s %f %f %f %s %s %s %s %s %s %s %s %s %s %s %f %s %s %s %s','HeaderLines',1,'Delimiter',',');
    time = datenum(S{2},'yyyy-mm-dd HH:MM:SS');
    [cat.data,ii] = sortrows(horzcat(time,S{3:5},S{17}));
    cat.id = S{1}(ii);
    cat.evtype = S{15}(ii);
%
% Unknown format
%
else
    disp('unknown catalog type')
end
%
% Close the file
%
fclose(fid);
%
% End of function
%
end
