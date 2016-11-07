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
%
% Load first catalog
%
fid1 = fopen(cat1.file, 'rt');
%
% Get Header Values
%
delimiter = ',';
endRow = 1;
formatSpec =  '%s';
dataArray = textscan(fid1,formatSpec,endRow,'ReturnOnError',false);
rawNames = strsplit(dataArray{1}{1},delimiter);
%
% Find Event ID
%
if any(strcmpi('ID',rawNames)) %Look for Time header
    IDInd = find(strcmpi('ID',rawNames));
elseif any(strcmpi('EventID',rawNames))
    IDInd = find(strcmpi('EventID',rawNames));
else
    error('No time or origin time header recognized.  Exiting.')
end
%
% Find Origin Time
%
if any(strcmpi('Time',rawNames)) %Look for Time header
    TimeInd = find(strcmpi('Time',rawNames));
elseif any(strcmpi('OriginTime',rawNames))
    TimeInd = find(strcmpi('OriginTime',rawNames));
elseif any(strcmpi('OT',rawNames))
    TimeInd = find(strcmpi('OT',rawNames));
else
    error('No time or origin time header recognized.  Exiting.')
end
%
% Find Latitude
%
if any(strcmpi('Latitude',rawNames)) %Look for Latitude header
    LatInd = find(strcmpi('Latitude',rawNames));
elseif any(strcmpi('Lat',rawNames))
    LatInd = find(strcmpi('Lat',rawNames));
else
    error('No latitude header recognized.  Exiting.')
end
%
% Find Longitude
%
if any(strcmpi('Longitude',rawNames)) %Look for Longitude header
    LonInd = find(strcmpi('Longitude',rawNames));
elseif any(strcmpi('Lon',rawNames))
    LonInd = find(strcmpi('Lon',rawNames));
else
    error('No longitude header recognized.  Exiting.')
end
%
% Find Depth
%
if any(strcmpi('Depth',rawNames)) %Look for Longitude header
    DepInd = find(strcmpi('Depth',rawNames));
elseif any(strcmpi('Dep',rawNames))
    DepInd = find(strcmpi('Dep',rawNames));
else
    error('No depth header recognized.  Please specify depth header as Depth or Dep...Exiting.')
end
%
% Find Magnitude
%
if any(strcmpi('Magnitude',rawNames)) %Look for Longitude header
    MagInd = find(strcmpi('Magnitude',rawNames));
elseif any(strcmpi('Mag',rawNames))
    MagInd = find(strcmpi('Mag',rawNames));
else
    error('No magnitude header recognized. Please specify header as Magnitude or Mag...Exiting.')
end
%
% Find EvType
%
if any(strcmpi('EventType',rawNames)) % Look for Event Type header
    TypeInd = find(strcmpi('EventType',rawNames));
elseif any(strcmpi('EvType',rawNames))
    TypeInd = find(strcmpi('EvType',rawNames));
elseif any(strcmpi('Type',rawNames))
    TypeInd = find(strcmpi('Type',rawNames));
elseif any(strcmpi('event-type',rawNames))
    TypeInd = find(strcmpi('event-type',rawNames));
else
    disp('No event type header recognized. Please specify header as EventType, EvType, or Type.')
    disp('Report will proceed but will assume all events are earthquakes')
end
%
% Get number of fields
%
NOF = size(rawNames,2);
% Create Format String
formatSpec = [];
for ii = 1 : NOF
    if ii == TimeInd || ii == TypeInd
        formatSpec = strcat(formatSpec,'%s');
    elseif ii == LatInd || ii == LonInd || ii == DepInd || ii == MagInd
        formatSpec = strcat(formatSpec,'%f');
    else
        formatSpec = strcat(formatSpec,'%q');
    end
end
%
% 
%
frewind(fid1);  
Tref = textscan(fid1,formatSpec,'HeaderLines',1,'Delimiter',',','EmptyValue',NaN); %ComCat Online CSV Upload
Tref{TimeInd} = strrep(Tref{TimeInd},'T',' ');
Tref{TimeInd} = strrep(Tref{TimeInd},'Z','');
Tref{TimeInd} = strrep(Tref{TimeInd},'/','-');
try
    Tref{TimeInd} = datenum(Tref{TimeInd},'yyyy-mm-dd HH:MM:SS.FFF');
catch
    try
        Tref{TimeInd} = datenum(Tref{TimeInd},'yyyy-mm-dd HH:MM:SS');
    catch
        try
            Tref{TimeInd} = datenum(Tref{TimeInd},'yyyy-mm-dd HH:MM') ;
        catch
            Tref{TimeInd} = str2double(Tref{TimeInd});
            Tref{TimeInd} = epoch_to_matlab(OriginTime);
        end
    end
end
ID = Tref{IDInd};
OriginTime = Tref{TimeInd};
Latitude = Tref{LatInd};
Longitude = Tref{LonInd};
Depth = Tref{DepInd};
Mag = Tref{MagInd};
if ~isempty(TypeInd)
    Type = Tref{TypeInd};
else
    Type = cell(size(OriginTime,1),1);
    for ii = 1 : size(Type,1)
        Type{ii} = 'earthquake';
    end
end
cat1.data = table(ID,OriginTime,Latitude,Longitude,Depth,Mag,Type);
cat1.data = sortrows(cat1.data,2);
%
% Close the file
%
fclose(fid1);
clear IDInd TimeInd LatInd LonInd DepInd MagInd TypeInd formatSpec NOF rawNames
clear dataArray
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Load second catalog
%
fid2 = fopen(cat2.file, 'rt');
%
% Get Header Values
%
delimiter = ',';
endRow = 1;
formatSpec =  '%s';
dataArray = textscan(fid2,formatSpec,endRow,'ReturnOnError',false);
rawNames = strsplit(dataArray{1}{1},delimiter);
%
% Find Event ID
%
if any(strcmpi('ID',rawNames)) %Look for Time header
    IDInd = find(strcmpi('ID',rawNames));
elseif any(strcmpi('EventID',rawNames))
    IDInd = find(strcmpi('EventID',rawNames));
else
    error('No time or origin time header recognized.  Exiting.')
end
%
% Find Origin Time
%
if any(strcmpi('Time',rawNames)) %Look for Time header
    TimeInd = find(strcmpi('Time',rawNames));
elseif any(strcmpi('OriginTime',rawNames))
    TimeInd = find(strcmpi('OriginTime',rawNames));
elseif any(strcmpi('OT',rawNames))
    TimeInd = find(strcmpi('OT',rawNames));
else
    error('No time or origin time header recognized.  Exiting.')
end
%
% Find Latitude
%
if any(strcmpi('Latitude',rawNames)) %Look for Latitude header
    LatInd = find(strcmpi('Latitude',rawNames));
elseif any(strcmpi('Lat',rawNames))
    LatInd = find(strcmpi('Lat',rawNames));
else
    error('No latitude header recognized.  Exiting.')
end
%
% Find Longitude
%
if any(strcmpi('Longitude',rawNames)) %Look for Longitude header
    LonInd = find(strcmpi('Longitude',rawNames));
elseif any(strcmpi('Lon',rawNames))
    LonInd = find(strcmpi('Lon',rawNames));
else
    error('No longitude header recognized.  Exiting.')
end
%
% Find Depth
%
if any(strcmpi('Depth',rawNames)) %Look for Longitude header
    DepInd = find(strcmpi('Depth',rawNames));
elseif any(strcmpi('Dep',rawNames))
    DepInd = find(strcmpi('Dep',rawNames));
else
    error('No depth header recognized.  Please specify depth header as Depth or Dep...Exiting.')
end
%
% Find Magnitude
%
if any(strcmpi('Magnitude',rawNames)) %Look for Longitude header
    MagInd = find(strcmpi('Magnitude',rawNames));
elseif any(strcmpi('Mag',rawNames))
    MagInd = find(strcmpi('Mag',rawNames));
else
    error('No magnitude header recognized. Please specify header as Magnitude or Mag...Exiting.')
end
%
% Find EvType
%
if any(strcmpi('EventType',rawNames)) % Look for Event Type header
    TypeInd = find(strcmpi('EventType',rawNames));
elseif any(strcmpi('EvType',rawNames))
    TypeInd = find(strcmpi('EvType',rawNames));
elseif any(strcmpi('Type',rawNames))
    TypeInd = find(strcmpi('Type',rawNames));
elseif any(strcmpi('event-type',rawNames))
    TypeInd = find(strcmpi('event-type',rawNames));
else
    disp('No event type header recognized. Please specify header as EventType, EvType, or Type.')
    disp('Report will proceed but will assume all events are earthquakes')
end
%
% Get number of fields
%
NOF = size(rawNames,2);
% Create Format String
formatSpec = [];
for ii = 1 : NOF
    if ii == TimeInd || ii == TypeInd
        formatSpec = strcat(formatSpec,'%s');
    elseif ii == LatInd || ii == LonInd || ii == DepInd || ii == MagInd
        formatSpec = strcat(formatSpec,'%f');
    else
        formatSpec = strcat(formatSpec,'%q');
    end
end
%
% 
%
frewind(fid2);  
Tref = textscan(fid2,formatSpec,'HeaderLines',1,'Delimiter',',','EmptyValue',NaN); %ComCat Online CSV Upload
Tref{TimeInd} = strrep(Tref{TimeInd},'T',' ');
Tref{TimeInd} = strrep(Tref{TimeInd},'Z','');
Tref{TimeInd} = strrep(Tref{TimeInd},'/','-');
try
    Tref{TimeInd} = datenum(Tref{TimeInd},'yyyy-mm-dd HH:MM:SS.FFF');
catch
    try
        Tref{TimeInd} = datenum(Tref{TimeInd},'yyyy-mm-dd HH:MM:SS');
    catch
        try
            Tref{TimeInd} = datenum(Tref{TimeInd},'yyyy-mm-dd HH:MM') ;
        catch
            Tref{TimeInd} = str2double(Tref{TimeInd});
            Tref{TimeInd} = epoch_to_matlab(OriginTime);
        end
    end
end
ID = Tref{IDInd};
OriginTime = Tref{TimeInd};
Latitude = Tref{LatInd};
Longitude = Tref{LonInd};
Depth = Tref{DepInd};
Mag = Tref{MagInd};
if ~isempty(TypeInd)
    Type = Tref{TypeInd};
else
    Type = cell(size(OriginTime,1),1);
    for ii = 1 : size(Type,1)
        Type{ii} = 'earthquake';
    end
end
cat2.data = table(ID,OriginTime,Latitude,Longitude,Depth,Mag,Type);
cat2.data = sortrows(cat2.data,2);
%
% Close the file
%
fclose(fid2);
end
% if(cat1.format == 1); % ComCat format
%   Tref = textscan(fid1,'%s %f %f %f %f %s %s %s %s %s %s %s %s %q %s %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',','); %ComCat Online CSV Upload
%   % Need to remove T and Z characters from DateTime string
%   Tref{1} = strrep(Tref{1},'T',' ');
%   Tref{1} = strrep(Tref{1},'Z','');
%   try
%       time = datenum(Tref{1},'yyyy-mm-dd HH:MM:SS.FFF');
%   catch
%       try
%             time = datenum(Tref{1},'yyyy-mm-dd HH:MM:SS');
%       catch
%             try
%                 time = datenum(Tref{1},'yyyy-mm-dd HH:MM') ;
%             catch
%                 time = str2double(Tref{1});
%                 time = epoch_to_matlab(time);
%             end
%       end
%   end
%   [cat1.data,ii] = sortrows(horzcat(time,Tref{2:5}),1);
%   cat1.id = Tref{12}(ii);
%   cat1.evtype = Tref{15}(ii);
% elseif(cat1.format == 2); % libcomcat format
%   S = textscan(fid1,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',','); 
%   % Need to remove T and Z characters from DateTime string
%   S{2} = strrep(S{2},'T',' ');
%   S{2} = strrep(S{2},'Z','');
%       try
%           time = datenum(S{2},'yyyy-mm-dd HH:MM:SS.FFF');
%       catch
%           try
%               time = datenum(S{2},'yyyy-mm-dd HH:MM:SS');
%           catch
%               try
%                   time = datenum(S{2},'yyyy-mm-dd HH:MM');
%               catch
%                 time = str2double(S{2});
%                 time = epoch_to_matlab(time);
%               end
%           end 
%       end
%   [cat1.data,ii] = sortrows(horzcat(time,S{3:6}),1);
%   cat1.id = S{1}(ii);
%   cat1.evtype = S{7}(ii);
% else
%     disp('unknown catalog type')
% end
% fclose(fid1);
%
% Load second catalog
%
% fid2 = fopen(cat2.file, 'rt');
% if(cat2.format == 1); % ComCat format
%   Tref = textscan(fid1,'%s %f %f %f %f %s %s %s %s %s %s %s %s %q %s %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',','); %ComCat Online CSV Upload
%   % Need to remove T and Z characters from DateTime string
%   Tref{1} = strrep(Tref{1},'T',' ');
%   Tref{1} = strrep(Tref{1},'Z','');
%   try
%       time = datenum(Tref{1},'yyyy-mm-dd HH:MM:SS.FFF');
%   catch
%       try
%             time = datenum(Tref{1},'yyyy-mm-dd HH:MM:SS');
%       catch
%             try
%                 time = datenum(Tref{1},'yyyy-mm-dd HH:MM') ;
%             catch
%                 disp('Time Format Not Recognized')
%             end
%       end
%   end
%   [cat2.data,ii] = sortrows(horzcat(time,Tref{2:5}),1);
%   cat2.id = Tref{12}(ii);
%   cat2.evtype = Tref{15}(ii);
% elseif(cat2.format == 2); % libcomcat format
%   S = textscan(fid1,'%s %s %f %f %f %f %s','HeaderLines',1,'Delimiter',','); 
%   % Need to remove T and Z characters from DateTime string
%   S{2} = strrep(S{2},'T',' ');
%   S{2} = strrep(S{2},'Z','');
%       try
%           time = datenum(S{2},'yyyy-mm-dd HH:MM:SS.FFF');
%       catch
%           try
%               time = datenum(S{2},'yyyy-mm-dd HH:MM:SS');
%           catch
%               try
%                   time = datenum(S{2},'yyyy-mm-dd HH:MM');
%               catch
%                   disp('Time Format Not Recognized')
%               end
%           end 
%       end
%   [cat2.data,ii] = sortrows(horzcat(time,S{3:6}),1);
%   cat2.id = S{1}(ii);
%   cat2.evtype = S{7}(ii);
% else
%     disp('unknown catalog type')
% end
% fclose(fid2);
% %
% % End of function
% %
% end