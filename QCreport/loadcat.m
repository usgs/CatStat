function [cat] = loadcat(cat)
% This function loads output from a ComCat Web search or feed in .CSV format
% NOTICE IN ORDER FOR THIS FUNCTION TO WORK PROPERLY THE FOLLOWING HEADER
% FIELDS MUST BE SPECIFIED: ID, ORIGINTIME, LATITUDE, LONGITUDE, DEPTH,
% AND MAGNITUDE.  EVENTTYPE HEADER IS OPTIONAL AND, IF IT IS NOT INCLUDED,
% THE PROGRAM WILL ASSUME ALL EVENTS ARE EARTHQUAKES
%
% Input: cat- information from initMkQCreport.dat file.  Read by mkQCreport 
%
% Output: Structure of catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   table of id, origin-time, lat, lon, depth, mag, and
%         event type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Get Header Values
    %
    delimiter = ',';
    endRow = 1;
    formatSpec =  '%s';
    dataArray = textscan(fid,formatSpec,endRow,'ReturnOnError', false);
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
    frewind(fid);  
    Tref = textscan(fid,formatSpec,'HeaderLines',1,'Delimiter',',','EmptyValue',NaN); %ComCat Online CSV Upload
    Tref{TimeInd} = strrep(Tref{TimeInd},'T',' ');
    Tref{TimeInd} = strrep(Tref{TimeInd},'Z','');
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
    cat.data = table(ID,OriginTime,Latitude,Longitude,Depth,Mag,Type);
    cat.data = sortrows(cat.data,2);
    %
    % Close the file
    %
    fclose(fid);
%
% End of function
%
end
