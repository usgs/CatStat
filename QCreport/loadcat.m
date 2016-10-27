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
if cat.format ~= 4
    fid = fopen(cat.file, 'rt');
else
    url = cat.file;
end
%
% ComCat format
%
if(cat.format == 1);
  Tref = textscan(fid,'%s %f %f %f %f %s %s %s %s %s %s %s %s %q %s %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',','); %ComCat Online CSV Upload
  % Need to remove T and Z characters from DateTime string
  Tref{1} = strrep(Tref{1},'T',' ');
  Tref{1} = strrep(Tref{1},'Z','');
  try
      time = datenum(Tref{1},'yyyy-mm-dd HH:MM:SS.FFF');
  catch
        try
            time = datenum(Tref{1},'yyyy-mm-dd HH:MM:SS');
        catch
            try
                time = datenum(Tref{1},'yyyy/mm/dd HH:MM:SS') ;
            catch
                time = str2double(Tref{1});
                time = epoch_to_matlab(time);
            end
        end
  end
  [cat.data,ii] = sortrows(horzcat(time,Tref{2:5}),1);
  cat.id = Tref{12}(ii);
  cat.evtype = Tref{15}(ii);
%
% libcomcat format
%
elseif(cat.format == 2); % libcomcat format
  S = textscan(fid,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',','); 
  % Need to remove T and Z characters from DateTime string
  S{2} = strrep(S{2},'T',' ');
  S{2} = strrep(S{2},'Z','');
      try
          time = datenum(S{2},'yyyy-mm-dd HH:MM:SS.FFF');
      catch
          try
              time = datenum(S{2},'yyyy-mm-dd HH:MM:SS');
          catch
              try
                  time = datenum(S{2},'yyyy/mm/dd HH:MM:SS');
              catch
                time = str2double(S{2});
                time = epoch_to_matlab(time);
              end
          end 
      end
  [cat.data,ii] = sortrows(horzcat(time,S{3:6}),1);
  cat.id = S{1}(ii);
  cat.evtype = S{7}(ii);
%
% iscgem catalog
%
elseif(cat.format == 3 ); 
    T = textscan(fid,'%s %f %f %f %f %f %s %f %f %s %f %f %s %s %f %f %s %f %f %f %f %f %f %s','HeaderLines',59,'Delimiter',',');
    % ISC-GEM date format yyyy-mm-dd HH:MM:SS.FF; need to append '0' to end
    T{1} = strcat(T{1},'0');
    % Now convert to datenum
    time = datenum(T{1},'yyyy-mm-dd HH:MM:SS.FFF');
    [cat.data,ii] = sortrows(horzcat(time,T{2},T{3},T{8},T{11}),1);
    cat.id = T{24}(ii);
    cat.evtype = cell(size(cat.data,1),1);
    for ii = 1 : size(cat.evtype,1)
        cat.evtype{ii} = 'earthquake';
    end
elseif(cat.format == 4);
    block = urlread(url);
    %
    % Try catch block in here; try to dl everything...if it fails get
    % starttime and endtime, break them up into months and concatenate
    % results...mimics getdata.csv
    %
    Tref = textscan(block,'%s %f %f %f %f %s %s %s %s %s %s %s %s %q %s %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',','); %ComCat Online CSV Upload
    % Need to remove T and Z characters from DateTime string
    Tref{1} = strrep(Tref{1},'T',' ');
    Tref{1} = strrep(Tref{1},'Z','');
    try
        time = datenum(Tref{1},'yyyy-mm-dd HH:MM:SS.FFF');
    catch
    try
        time = datenum(Tref{1},'yyyy-mm-dd HH:MM:SS');
    catch
        try
            time = datenum(Tref{1},'yyyy/mm/dd HH:MM:SS') ;
        catch
            time = str2double(Tref{1});
            time = epoch_to_matlab(time);
        end
    end
    end
    [cat.data,ii] = sortrows(horzcat(time,Tref{2:5}),1);
    cat.id = Tref{12}(ii);
    cat.evtype = Tref{15}(ii);
%
    disp('Catalog Type Unknown')
end
%
% Close the file
%
if cat.format ~= 4
    fclose(fid);
end
%
% End of function
%
end
