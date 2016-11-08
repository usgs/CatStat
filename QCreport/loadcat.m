function [cat] = loadcat(cat)
% This function loads an earthquake catalog or bulletin in CSV format.
%%%%%%%%%%%%%%%%%%%%%%%%%  NOTICE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IN ORDER FOR THIS FUNCTION TO WORK PROPERLY THE FOLLOWING HEADER
% FIELDS MUST BE SPECIFIED: ID, ORIGINTIME, LATITUDE, LONGITUDE, DEPTH,
% AND MAGNITUDE.  EVENTTYPE HEADER IS OPTIONAL. IF IT IS NOT INCLUDED
% THE PROGRAM WILL ASSUME ALL EVENTS ARE EARTHQUAKES.  HEADER VALUES ARE
% NOT CASE SENSITIVE.
%
% Input: cat- information gathered from initMkQCreport.dat file read by
% mkQCreport.  If running loadcat seperately, cat is a structure that
% contains the following fields:
%           cat.file: path to CSV file
%           cat.name: Name of catalog
%           cat.timeoffset: Local time UTC offset
%           cat.timezone: Description of time zone
%
% Output: Structure of catalog data
%         All input variables described above are returned along with:
%         cat.data   table of ID, OriginTime, Latitude, Longitude, Depth,
%                    Mag, and Type
%
% Written By: Matthew R. Perry
% Last Edit: 08 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fid = fopen(cat.file,'rt');
    if fid == -1
        error('File cannot be located.  Please check the path specified in the input file.  Exiting')
    end
    %
    % Get Header Values
    %
    delimiter = ',';
    endRow = 1;
    formatSpec =  '%s';
    dataArray = textscan(fid,formatSpec,endRow,'ReturnOnError', false);
    rawNames = strsplit(dataArray{1}{1},delimiter);
    %
    % Find Event
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
        TypeInd = [];
    end
    %
    % Get number of fields (NOF)
    %
    NOF = size(rawNames,2);
    %
    % Create Format String
    %
    formatSpec = [];
    for ii = 1 : NOF
        if ii == TimeInd | ii == TypeInd
            formatSpec = strcat(formatSpec,'%s');
        elseif ii == LatInd || ii == LonInd || ii == DepInd || ii == MagInd
            formatSpec = strcat(formatSpec,'%f');
        else
            formatSpec = strcat(formatSpec,'%q');
        end
    end
    %
    % Rewind file and skip headerline
    %
    frewind(fid);  
    Tref = textscan(fid,formatSpec,'HeaderLines',1,'Delimiter',',','EmptyValue',NaN); %ComCat Online CSV Upload
    if strcmpi(cat.epoch,'No')
        %
        % LibComCat queries return dates as yyyy-mm-ddTHH:MM:SS.FFFZ, which
        % MATLAB doesn't like.
        %
        Tref{TimeInd} = strrep(Tref{TimeInd},'T',' ');
        Tref{TimeInd} = strrep(Tref{TimeInd},'Z','');
        %
        % Replace any slashes in OriginTime with dashes
        %
        Tref{TimeInd} = strrep(Tref{TimeInd},'/','-');
        %
        % If date time string is variable, this try/catch will hopefully
        % capture all variations.
        %
        try
            Tref{TimeInd} = datenum(Tref{TimeInd},'yyyy-mm-dd HH:MM:SS.FFF');
        catch
            try
                Tref{TimeInd} = datenum(Tref{TimeInd},'yyyy-mm-dd HH:MM:SS');
            catch
                Tref{TimeInd} = datenum(Tref{TimeInd},'yyyy-mm-dd HH:MM') ;
            end
        end
    elseif strcmpi(cat.epoch,'Yes')
        Tref{TimeInd} = str2double(Tref{TimeInd});
        Tref{TimeInd} = epoch_to_matlab(OriginTime);
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
    cat.data = table(ID,OriginTime,Latitude,Longitude,Depth,Mag,Type);
    cat.data = sortrows(cat.data,2);
    %
    % Close the file
    %
    fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Internal Functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [time_matlab] = epoch_to_matlab(epoch_time)
        % Converts unix epoch time to MATLAB datenum
        time_reference = datenum('1970','yyyy');
        time_matlab = time_reference + epoch_time./86400;
    end
%
% End of function
%
end
