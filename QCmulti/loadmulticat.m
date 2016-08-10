function [cat1, cat2] = loadmulticat(cat1, cat2)
% This function will load in the two catalogs (cat1 and cat2) based on the
% information provided in the initMkQCmulti.dat file.
%
% Inputs -
% cat1 - Information concerning the first catalog. Created by mkQCmulti
% cat2 - Information concerning the second catalog.  Created by mkQCmulti
%
% Outputs -
% cat1 - Information and data for the first catalog
% cat2 - Information and data for the second catalog
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Begin function
%
% Load first catalog
%
fid1 = fopen(cat1.file, 'rt');
if(cat1.format == 1); % ComCat format
  Tref = textscan(fid1,'%s %f %f %f %f %s %s %s %s %s %s %s %s %q %s %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',','); %ComCat Online CSV Upload
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
                time = datenum(Tref{1},'yyyy-mm-dd HH:MM') ;
            catch
                disp('Time Format Not Recognized')
            end
      end
  end
  [cat1.data,ii] = sortrows(horzcat(time,Tref{2:5}),1);
  cat1.id = Tref{12}(ii);
  cat1.evtype = Tref{15}(ii);
elseif(cat1.format == 2); % libcomcat format
  S = textscan(fid1,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',','); 
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
                  time = datenum(S{2},'yyyy-mm-dd HH:MM');
              catch
                  disp('Time Format Not Recognized')
              end
          end 
      end
  [cat1.data,ii] = sortrows(horzcat(time,S{3:6}),1);
  cat1.id = S{1}(ii);
  cat1.evtype = S{7}(ii);
else
    disp('unknown catalog type')
end
fclose(fid1);
%
% Load second catalog
%
fid2 = fopen(cat2.file, 'rt');
if(cat2.format == 1); % ComCat format
  Tref = textscan(fid1,'%s %f %f %f %f %s %s %s %s %s %s %s %s %q %s %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',','); %ComCat Online CSV Upload
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
                time = datenum(Tref{1},'yyyy-mm-dd HH:MM') ;
            catch
                disp('Time Format Not Recognized')
            end
      end
  end
  [cat2.data,ii] = sortrows(horzcat(time,Tref{2:5}),1);
  cat2.id = Tref{12}(ii);
  cat2.evtype = Tref{15}(ii);
elseif(cat2.format == 2); % libcomcat format
  S = textscan(fid1,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',','); 
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
                  time = datenum(S{2},'yyyy-mm-dd HH:MM');
              catch
                  disp('Time Format Not Recognized')
              end
          end 
      end
  [cat2.data,ii] = sortrows(horzcat(time,S{3:6}),1);
  cat2.id = S{1}(ii);
  cat2.evtype = S{7}(ii);
else
    disp('unknown catalog type')
end
fclose(fid2);
%
% End of function
%
end