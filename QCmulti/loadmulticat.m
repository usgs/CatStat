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
  Tref = textscan(fid1,'%s %f %f %f %f %s %s %s %s %s %s %s %s %q %s','HeaderLines',1,'Delimiter',','); %ComCat Online CSV Upload
  time = datenum(Tref{1},'yyyy-mm-ddTHH:MM:SS.FFFZ');
  [cat1.data,ii] = sortrows(horzcat(time,Tref{2:5}),1);
  cat1.id = Tref{12}(ii);
  cat1.evtype = Tref{15}(ii);
elseif(cat1.format == 2); % libcomcat format
  S = textscan(fid1,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',','); 
  time = datenum(S{2},'yyyy-mm-dd HH:MM:SS.FFF');
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
  Tref = textscan(fid2,'%s %f %f %f %f %s %s %s %s %s %s %s %s %q %s','HeaderLines',1,'Delimiter',','); %ComCat Online CSV Upload
  time = datenum(Tref{1},'yyyy-mm-ddTHH:MM:SS.FFFZ');
  [cat2.data,ii] = sortrows(horzcat(time,Tref{2:5}),1);
  cat2.id = Tref{12}(ii);
  cat2.evtype = Tref{15}(ii);
elseif(cat2.format == 2); % libcomcat format
  S = textscan(fid1,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',','); 
  time = datenum(S{2},'yyyy-mm-dd HH:MM:SS.FFF');
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