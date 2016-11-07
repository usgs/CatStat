function [missing, dist, dep, mags, both, matching] ...
    = compareevnts(cat1,cat2,tmax,delmax,magdelmax,depdelmax,auth,outputDir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function compares entries in the catalog to determine events that
% either match or do not meet the matching criteria.  Those that do not
% meet the matching criteria as delineated into 3 subcategories: locations
% not close enough (dist), depth residual outside limit (dep), and
% magnitude residual outside limit (mag).  Ideally, the number of events
% not matching and the number of events matching should equal the number of
% events in the catalogs.  If this does not occur, duplicate events are
% present in either of the catalogs.  A later version of this function will
% address this issue, but for now a message will print out if duplicate
% events are possible.
%
% Inputs - 
%   cat1 - Catalog 1 information and data
%   cat2 - Catalog 2 information and data
%   tmax - Maximum time window for matching events
%   delmax - Maximum location difference for matching events
%   magdelmax - Maximum magnitude residual for matching events
%   depdelmax - Maximum depth residual for matching events
%   auth - Authoritative agency abbreviation.
%
% Outputs -
%   missing - data for the events missing from either catalog
%   dist - data for the events that match in time but not location
%   dep - data for the events that match in time and location but not depth
%   mags - data for the events that match in time, location, and depth, but
%   not magnitude.
%   types - SECTION NOT COMPLETE YET
%   matching - data for the events that met all the matching criteria
%   dup - Possible list of duplicate events
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Useful variables
%
N = length(auth);
FormatSpec1 = '%-20s %-20s %-8s %-9s %-7s %-7s %-7s %-7s %-7s %-7s\n';
FormatSpec2 = '%-20s %-20s %-8s %-9s %-7s %-7s \n';
sec_per_day = 86400;
size_cat1 = size(cat1.data,1);
size_cat2 = size(cat2.data,1);
if ~strcmpi('none',cat1.auth)
    size_authcat1 = size(cat1.data.ID(strncmpi(cat1.auth,cat1.data.ID,N)),1);
    size_authcat2 = size(cat2.data.ID(strncmpi(cat2.auth,cat2.data.ID,N)),1);
end
%
% Convert Time window
%
tmax = tmax/sec_per_day;
time_window =1*24*60*60; %1 day time window
time_window = time_window/sec_per_day;
%
% Empty matrices
%
missing.cat1 = [];
missing.cat2 = [];
dist.cat1 = [];
dist.cat2 = []; 
dep.cat1 = []; dep.cat2 = [];
mags.cat1 = []; mags.cat2 = [];
both.cat1 = []; both.cat2 = [];
matching.cat1 =[]; matching.cat2 = [];
%
% Event Counters
%
m = 0; % Missing events
d = 0; % Matching in time but not distance events
M = 0; % Matching events (time and distance only(
D = 0; % Matching events but depth is off
G = 0; % Matching events but magnitude is off
B = 0; % Matching events but mangnitude and depth are off
P = 0; % Duplicate events
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Check to see if authoritative agency is selected
%
for ii = 1 : size(cat1.data,1)
    %
    % Find those events indices within 1 day
    %
    cat2_ind = find(abs((cat1.data.OriginTime(ii)-cat2.data.OriginTime))<=time_window);
    %
    % Check for matching ids
    %
    cat2match_ind = find(strcmp(cat1.data.ID(ii,1),cat2.data.ID(cat2_ind)));
    cat2match_ind = cat2_ind(cat2match_ind);
    if ~isempty(cat2match_ind) && ~isempty(cat2_ind)
        M=M+1;
        matching_ind(M,:) = [ii,cat2match_ind];
    else
        if isnan(magdelmax) && isnan(depdelmax)
            clear C;
            C(:,1) = (cat1.data.OriginTime(ii)-cat2.data.OriginTime(cat2_ind))./tmax;
            C(:,2) = distance_hvrsn(cat1.data.Latitude(ii),...
                cat1.data.Longitude(ii),cat2.data.Latitude(cat2_ind),...
                cat2.data.Longitude(cat2_ind))./delmax;
            %
            % Minimize L2 norm of each row
            %
            [~,ind] = min(sqrt(sum(abs(C).^2,2)));
            %
            % Event of Interest row index in catalog 2
            %
            EOI = cat2_ind(ind);
            %
            % Check to make sure C(ind,1)
            %
            if isempty(C)
                m=m+1;
                missing_ind1(m,:) = ii;
            elseif abs(C(ind,1)) > 1 || abs(C(ind,2)) > 1
                m=m+1;
                missing_ind1(m,:) = ii;
            else
                M=M+1;
                matching_ind(M,:) = [ii,EOI];
            end
        elseif ~isnan(magdelmax) && isnan(depdelmax)
            clear C;
            C(:,1) = (cat1.data.OriginTime(ii)-cat2.data.OriginTime(cat2_ind))./tmax;
            C(:,2) = distance_hvrsn(cat1.data.Latitude(ii),...
                cat1.data.Longitude(ii),cat2.data.Latitude(cat2_ind),...
                cat2.data.Longitude(cat2_ind))./delmax;
            C(:,3) = (cat1.data.Mag(ii) - cat2.data.Mag(cat2_ind))./magdelmax;
            %
            % Minimize L2 norm of each row
            %
            [~,ind] = min(sqrt(sum(abs(C).^2,2)));
            %
            % Event of Interest row index in catalog 2
            %
            EOI = cat2_ind(ind);
            %
            % Check to make sure C(ind,1)
            %
            if isempty(C)
                m=m+1;
                missing_ind1(m,:) = ii;
            elseif abs(C(ind,1)) > 1 || abs(C(ind,2)) > 1
                m=m+1;
                missing_ind1(m,:) = ii;
            else
                M=M+1;
                matching_ind(M,:) = [ii,EOI];
                if abs(C(ind,3)) > 1
                    G=G+1;
                    mag_ind(G,:) = [ii,EOI];
                end
            end
        elseif isnan(magdelmax) && ~isnan(depdelmax)
            clear C;
            C(:,1) = (cat1.data.OriginTime(ii)-cat2.data.OriginTime(cat2_ind))./tmax;
            C(:,2) = distance_hvrsn(cat1.data.Latitude(ii),...
                cat1.data.Longitude(ii),cat2.data.Latitude(cat2_ind),...
                cat2.data.Longitude(cat2_ind))./delmax;
            C(:,3) = (cat1.data.Depth(ii) - cat2.data.Depth(cat2_ind))./depdelmax;
            %
            % Minimize L2 norm of each row
            %
            [~,ind] = min(sqrt(sum(abs(C).^2,2)));
            %
            % Event of Interest row index in catalog 2
            %
            EOI = cat2_ind(ind);
            %
            % Check to make sure C(ind,1)
            %
            if isempty(C)
                m=m+1;
                missing_ind1(m,:) = ii;
            elseif abs(C(ind,1)) > 1 || abs(C(ind,2)) > 1
                m=m+1;
                missing_ind1(m,:) = ii;
            else
                M=M+1;
                matching_ind(M,:) = [ii,EOI];
                if abs(C(ind,3)) > 1
                    D=D+1;
                    dep_ind(D,:) = [ii, EOI];
                end
            end
        elseif ~isnan(magdelmax) && ~isnan(depdelmax)
            clear C;
            C(:,1) = (cat1.data.OriginTime(ii)-cat2.data.OriginTime(cat2_ind))./tmax;
            C(:,2) = distance_hvrsn(cat1.data.Latitude(ii),...
                cat1.data.Longitude(ii),cat2.data.Latitude(cat2_ind),...
                cat2.data.Longitude(cat2_ind))./delmax;
            C(:,3) = (cat1.data.Depth(ii) - cat2.data.Depth(cat2_ind))./depdelmax;
            C(:,4) = (cat1.data.Mag(ii) - cat2.data.Mag(cat2_ind))./magdelmax;
            %
            % Minimize L2 norm of each row
            %
            [~,ind] = min(sqrt(sum(abs(C).^2,2)));
            %
            % Event of Interest row index in catalog 2
            %
            EOI = cat2_ind(ind);
            %
            % Check to make sure C(ind,1)
            %
            if isempty(C)
                m=m+1;
                missing_ind1(m,:) = ii;
            elseif abs(C(ind,1)) > 1 || abs(C(ind,2)) > 1
                m=m+1;
                missing_ind1(m,:) = ii;
            else
                M=M+1;
                matching_ind(M,:) = [ii,EOI];
                if abs(C(ind, 3)) > 1 %& abs(C(ind,4)) <= 1
                    D=D+1;
                    dep_ind = [ii,EOI];
                elseif abs(C(ind, 3)) <= 1 && abs(C(ind,4)) > 1
                    %
                    % If magnitude residual is too great, but dep red in tolerance
                    %
                    G=G+1;
                    mag_ind(G,:) = [ii,EOI];
                elseif abs(C(ind, 3)) > 1 && abs(C(ind, 4)) > 1
                    %
                    % If both mag res and dep res out of tolerance
                    %
                    B=B+1;
                    both_ind(B,:) = [ii,EOI];
                end
            end
        end
    end
end
%
% Parse table
%
%
% Missing Events
%
missing.cat1 = cat1.data(missing_ind1(:,1),:);
%
% Matching Events
%
delD = distance_hvrsn(cat1.data.Latitude(matching_ind(:,1)),cat1.data.Longitude(matching_ind(:,1)),...
    cat2.data.Latitude(matching_ind(:,2)), cat2.data.Longitude(matching_ind(:,2)));
delDepth = cat1.data.Depth(matching_ind(:,1)) - cat2.data.Depth(matching_ind(:,2));
delMag = cat1.data.Mag(matching_ind(:,1)) - cat2.data.Mag(matching_ind(:,2));
delTime = cat1.data.OriginTime(matching_ind(:,1)) - cat2.data.OriginTime(matching_ind(:,2));
dels = table(delD,delDepth,delMag,delTime);
matching.cat1 = [cat1.data(matching_ind(:,1),:),dels];
matching.cat2 = cat2.data(matching_ind(:,2),:);
%
% Mag Issues
%
if G ~= 0
    mags.cat1 = cat1.data(mag_ind(:,1),:);
    mags.cat2 = cat2.data(mag_ind(:,2),:);
end
%
% Depth Issues
%
if D ~= 0
    dep.cat1 = cat1.data(dep_ind(:,1),:);
    dep.cat2 = cat2.data(dep_ind(:,2),:);
end
%
% Mag and Dist Issues
%
if B ~= 0
    both.cat1 = cat1.data(both_ind(:,1),:);
    both.cat2 = cat2.data(both_ind(:,2),:);
end
%
% Remove events already parsed
%
cat1_ind = [matching_ind(:,1);missing_ind1(:,1)];
cat2_ind = [matching_ind(:,2)];
cat1.data(cat1_ind,:) = [];
cat2.data(cat2_ind,:) = [];
%
% Parse remaining cat2 data
%
missing.cat2 = cat2.data;
m1 = m;
m = size(missing.cat2,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Check matching events for matching event types
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EvTypeInd = find(~strcmpi(matching.cat1.Type,matching.cat2.Type));
if ~isempty(EvTypeInd)
    disp(' ')
    disp(['The following matching events has mismatched event types'])
    for ii = 1 : size(EvTypeInd)
        disp([matching.cat1.ID(EvTypeInd(ii)),'/',matching.cat1.Type(EvTypeInd(ii)),...
            '---',matching.cat2.ID(EvTypeInd(ii)),'/',matching.cat2.Type(EvTypeInd(ii))])
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check for authoritative sources; if selected
%
% For matching events:
% Check which matching pairs are authoritative:
% Case 1: Both Authoritative (EventIDs should match!)
% Case 2: Cat1 Authoritative, Cat2 Nonauthoritative
% Case 3: Cat1 Nonauthoritative, Cat2 authoritative
% Case 4: Neither are authoritative
%
% For missing events:
% Check if any missing events are authoritative
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~strcmpi('none',auth)
    matching.authboth = find(strncmpi(cat1.auth,matching.cat1.ID,N) & ...
        strncmpi(cat2.auth,matching.cat2.ID,N));
    matching.authcat1 = find(strncmpi(cat1.auth,matching.cat1.ID,N) & ...
        ~strncmpi(cat2.auth,matching.cat2.ID,N));
    matching.authcat2 = find(~strncmpi(cat1.auth,matching.cat1.ID,N) & ...
        strncmpi(cat2.auth,matching.cat2.ID,N));
    matching.neither = find(~strncmpi(cat1.auth,matching.cat1.ID,N) & ...
        ~strncmpi(cat2.auth,matching.cat2.ID,N));
    missing.cat1auth = find(strncmpi(cat1.auth,missing.cat1.ID,N));
    missing.cat2auth = find(strncmpi(cat2.auth,missing.cat2.ID,N));
    missing.cat1nonauth = find(~strncmpi(cat1.auth,missing.cat1.ID,N));
    missing.cat2nonauth = find(~strncmpi(cat2.auth,missing.cat2.ID,N));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Summary Information
%
disp('-- Number of events after filtering --')
disp([num2str(size_cat1),' ',cat1.name,' events in the target region.'])
disp([num2str(size_cat2),' ',cat2.name,' events in the target region.'])
disp(' ')
%
%Matching Events
%
disp('      ---------------- MATCHING EVENTS ----------------    ')
if ~isempty(matching.cat1)
    disp([num2str(M),' ',cat1.name,' and ',cat2.name, ' events meet matching criteria.'])
else
    disp('No matching events')
end
disp(' ')
%
%Missing Events
%
disp('   -------------------- MISSING EVENTS --------------------   ')
disp(' ')
disp('                  ---Total Missing Events---                  ')
if ~isempty(missing.cat1)
    disp(['There are ',num2str(size(missing.cat1,1)),' event(s) in ',cat1.name])
    disp(['missing from ',cat2.name])
else
    disp(['No events from ',cat1.name,' missing from ',cat2.name,'.'])
end
if ~isempty(missing.cat2)
    disp(['There are ',num2str(size(missing.cat2,1)),' event(s) in ',cat2.name])
    disp(['missing from ',cat1.name])
else
    disp(['No events from ',cat2.name,' missing from ',cat1.name,'.'])
end
disp(' ')
disp('---- No Similar Origin Times ----')
if ~isempty(missing.cat1)
    disp([num2str(m1),' event(s) in ', cat1.name, ' have origin times not in ', cat2.name])
else
    disp(['0 event(s) in ',cat1.name, ' have origin time not in ', cat2.name])
end
if ~isempty(missing.cat2)
    disp([num2str(m), ' event(s) in ', cat2.name, ' have origin times not in ', cat1.name])
    disp(' ')
else
    disp(['0 event(s) in ',cat2.name, ' have origin time not in ', cat1.name])
    disp(' ')
end
%
%Matching events that have possible data errors
%
disp(['-------------------- POSSIBLE PROBLEM EVENTS ---------------    '])
if ~isempty(dep.cat1)
    disp([num2str(D),' events matched but depths were greater than ',num2str(depdelmax),' km apart']);
end
if ~isempty(mags.cat1)
    disp([num2str(G),' events matched but magnitude residuals were greater than ',num2str(magdelmax),'.']);
end
if ~isempty(both.cat1)
    disp([num2str(B),' events matched but magnitude and depth residuals were greater than ',num2str(magdelmax),' and ',num2str(depdelmax),' km, respectively.']);
end
disp(' ')
%
%Possible Duplicate Events
%
FormatSpec1 = '%-20s %-20s %-8s %-9s %-7s %-7s %-7s %-7s %-7s %-7s\n';
FormatSpec2 = '%-20s %-20s %-8s %-9s %-7s %-7s \n';
if size_cat1 < m1+M || size_cat2 < m+M
    disp('--------MULTIPLE EVENT MATCHES-----------')
    disp('')
    %
    % Check for unique IDs in catalog 1
    %
    [~,uniqueIdx1] = unique(matching.cat1.ID);
    dups1 = matching.cat1.ID;
    dups1(uniqueIdx1) = [];
    dups1 = unique(dups1);
    if ~isempty(dups1)
        disp(['Multiple matches in ',cat1.name,' with events in ',cat2.name,'--------'])
        fprintf(FormatSpec1,'Event ID', 'Origin Time','Lat.','Lon.','Dep(km)','Mag','LocRes','DepRes','magRes','TimeRes')
        for ii = 1 : size(dups1,1)
            dups_idx1 = find(strcmpi(dups1(ii,1),matching.cat1.ID));
            %
            % Only print the duplicate event once
            %
            fprintf(FormatSpec2,matching.cat1.ID{dups_idx1(1)},...
                datestr(matching.cat1.OriginTime(dups_idx1(1)),'yyyy/mm/dd HH:MM:SS'),...
                num2str(matching.cat1.Latitude(dups_idx1(1))), ...
                num2str(matching.cat1.Longitude(dups_idx1(1))),...
                num2str(matching.cat1.Depth(dups_idx1(1))),...
                num2str(matching.data.Mag(dups_idx1(1))));
            disp('**')
            for jj = 1 : size(dups_idx1)
                %
                % Print the events from catalog 2
                %
                fprintf(FormatSpec1,matching.cat2.ID{dups_idx1(jj)},...
                    datestr(matching.cat2.OriginTime(dups_idx1(jj)),'yyyy/mm/dd HH:MM:SS'),...
                    num2str(matching.cat2.Latitude(dups_idx1(jj))),...
                    num2str(matching.cat2.Longitude(dups_idx1(jj))),...
                    num2str(matching.cat2.Depth(dups_idx1(jj))),...
                    num2str(matching.cat2.Mag(dups_idx1(jj))),...
                    num2str(matching.cat1.delD(dups_idx1(jj))),...
                    num2str(matching.cat1.delDepth(dups_idx1(jj))),...
                    num2str(matching.cat1.delMag(dups_idx1(jj))),...
                    num2str(matching.cat1.delTime(dups_idx1(jj))));
            end
            disp('--')
        end
    end
    %
    % Repeat for catalog 2 events
    %
    [~,uniqueIdx2] = unique(matching.cat2.ID);
    dups2 = matching.cat2.ID;
    dups2(uniqueIdx2) = [];
    dups2 = unique(dups2);
    if ~isempty(dups2)
        disp(['Multiple matches in ',cat2.name,' with events in ',cat1.name,'--------'])
        fprintf(FormatSpec1,'Event ID', 'Origin Time','Lat.','Lon.','Dep(km)','Mag','LocRes','DepRes','magRes','TimeRes')
        for ii = 1 : size(dups2,1)
            dups_idx2 = find(strcmpi(dups2(ii,1),matching.cat2.ID));
            %
            % Only print the duplicate event once
            %
            fprintf(FormatSpec2,matching.cat2.ID{dups_idx2(1)},...
                datestr(matching.cat2.OriginTime(dups_idx2(1)),'yyyy/mm/dd HH:MM:SS'),...
                num2str(matching.cat2.Latitude(dups_idx2(1))),...
                num2str(matching.cat2.Longitude(dups_idx2(1))),...
                num2str(matching.cat2.Depth(dups_idx2(1))),...
                num2str(matching.cat2.Mag(dups_idx2(1))));
            disp('***')
            for jj = 1 : size(dups_idx2)
                %
                % Print the events from catalog 2
                %
                fprintf(FormatSpec1,matching.cat1.ID{dups_idx2(jj)},...
                    datestr(matching.cat1.OriginTime(dups_idx2(jj)),'yyyy/mm/dd HH:MM:SS'),...
                    num2str(matching.cat1.Latitude(dups_idx2(jj))),...
                    num2str(matching.cat1.Longitude(dups_idx2(jj))),...
                    num2str(matching.cat1.Depth(dups_idx2(jj))),...
                    num2str(matching.cat1.Mag(dups_idx2(jj))),...
                    num2str(matching.cat1.delD(dups_idx2(jj))),...
                    num2str(matching.cat1.delDepth(dups_idx2(jj))),...
                    num2str(matching.cat1.delMag(dups_idx2(jj))),...
                    num2str(matching.cat1.delTime(dups_idx2(jj))));
            end
            disp('--')
        end
    end      
end
disp(' ')
if ~strcmpi('none',auth)
    disp('-------AUTHORITATIVE EVENT CHECK------------')
    disp(' ')
    disp([num2str(size_authcat1/size_cat1*100),'% ',...
        'of ',cat1.name,' events are ',cat1.auth,' authoritative.'])
    disp([num2str(size_authcat2/size_cat2*100),'% ',...
        'of ',cat2.name,' events are ',cat2.auth,' authoritative.'])
    if ~isempty(matching.authboth)
        disp([num2str(size(matching.authboth,1)),...
            ' events are matching and ',cat1.auth,' authoritative in both catalogs (',...
            num2str(size(matching.authboth,1)/size(matching.cat1,1)*100),'% of matching events)'])
        disp(' ')
    end
    if ~isempty(matching.authcat1) %Not authoritative in Cat2
        disp([num2str(size(matching.authcat1,1)),...
            ' events are matching, but are ',cat1.auth,' authoritative only in ',cat1.name,' (',...
            num2str(size(matching.authcat1,1)/size(matching.cat1,1)*100),'% of matching events)']);
        disp('-------------------')
        for ii = 1 : size(matching.authcat1,1)
            fprintf(FormatSpec1,matching.cat1.ID(matching.authcat1(ii)),...
                datestr(matching.cat1.OriginTime(matching.authcat1(ii)),'yyyy-mm-dd HH:MM:SS.FFF'),...
                num2str(matching.cat1.Latitude(matching.authcat1(ii))),...
                num2str(matching.cat1.Longitude(matching.authcat1(ii))),...
                num2str(matching.cat1.Depth(matching.authcat1(ii))),...
                num2str(matching.cat1.Mag(matching.authcat1(ii))),...
                num2str(matching.cat1.delD(matching.authcat1(ii))),...
                num2str(matching.cat1.delDepth(matching.authcat1(ii))),...
                num2str(matching.cat1.delMag(matching.authcat1(ii))),...
                num2str(matching.cat1.delTime(matching.authcat1(ii))));
            fprintf(FormatSpec2,matching.cat2.ID(matching.authcat1(ii)),...
                datestr(matching.cat2.OriginTime(matching.authcat1(ii)),'yyyy-mm-dd HH:MM:SS.FFF'),...
                num2str(matching.cat2.Latitude(matching.authcat1(ii))),...
                num2str(matching.cat2.Longitude(matching.authcat1(ii))),...
                num2str(matching.cat2.Depth(matching.authcat1(ii))),...
                num2str(matching.cat2.Mag(matching.authcat1(ii))));
        end
    end
    if ~isempty(matching.authcat2) %Not authoritative in Cat1
        disp([num2str(size(matching.authcat2,1)),...
            ' events are matching, but are ',cat1.auth,' authoritative only in ',cat2.name,' (',...
            num2str(size(matching.authcat2,1)/size(matching.cat1,1)*100),'% of matching events)']);
        disp('-------------------')
        for ii = 1 : size(matching.authcat2,1)
            fprintf(FormatSpec1,matching.cat1.ID(matching.authcat2(ii)),...
                datestr(matching.cat1.OriginTime(matching.authcat2(ii)),'yyyy-mm-dd HH:MM:SS.FFF'),...
                num2str(matching.cat1.Latitude(matching.authcat2(ii))),...
                num2str(matching.cat1.Longitude(matching.authcat2(ii))),...
                num2str(matching.cat1.Depth(matching.authcat2(ii))),...
                num2str(matching.cat1.Mag(matching.authcat2(ii))),...
                num2str(matching.cat1.delD(matching.authcat2(ii))),...
                num2str(matching.cat1.delDepth(matching.authcat2(ii))),...
                num2str(matching.cat1.delMag(matching.authcat2(ii))),...
                num2str(matching.cat1.delTime(matching.authcat2(ii))));
            fprintf(FormatSpec2,matching.cat2.ID(matching.authcat2(ii)),...
                datestr(matching.cat2.OriginTime(matching.authcat2(ii)),'yyyy-mm-dd HH:MM:SS.FFF'),...
                num2str(matching.cat2.Latitude(matching.authcat2(ii))),...
                num2str(matching.cat2.Longitude(matching.authcat2(ii))),...
                num2str(matching.cat2.Depth(matching.authcat2(ii))),...
                num2str(matching.cat2.Mag(matching.authcat2(ii))));
        end
    end
    if ~isempty(matching.neither) %Not authoritative in either
        disp([num2str(size(matching.neither,1)),...
            ' events are matching, but are not ',cat1.auth,' authoritative in either catalog (',...
            num2str(size(matching.neither,1)/size(matching.cat1,1)*100),'% of matching events)']);
        disp('-------------------')
        for ii = 1 : size(matching.authcat2,1)
            fprintf(FormatSpec1,matching.cat1.ID(matching.neither(ii)),...
                datestr(matching.cat1.OriginTime(matching.neither(ii)),'yyyy-mm-dd HH:MM:SS.FFF'),...
                num2str(matching.cat1.Latitude(matching.neither(ii))),...
                num2str(matching.cat1.Longitude(matching.neither(ii))),...
                num2str(matching.cat1.Depth(matching.neither(ii))),...
                num2str(matching.cat1.Mag(matching.neither(ii))),...
                num2str(matching.cat1.delD(matching.neither(ii))),...
                num2str(matching.cat1.delDepth(matching.neither(ii))),...
                num2str(matching.cat1.delMag(matching.neither(ii))),...
                num2str(matching.cat1.delTime(matching.neither(ii))));
            fprintf(FormatSpec2,matching.cat2.ID(matching.neither(ii)),...
                datestr(matching.cat2.OriginTime(matching.neither(ii)),'yyyy-mm-dd HH:MM:SS.FFF'),...
                num2str(matching.cat2.Latitude(matching.neither(ii))),...
                num2str(matching.cat2.Longitude(matching.neither(ii))),...
                num2str(matching.cat2.Depth(matching.neither(ii))),...
                num2str(matching.cat2.Mag(matching.neither(ii))));
        end
    end
    if ~isempty(missing.cat1auth) %Authoritative in Cat1 but missing from Cat2
        disp([num2str(size(missing.cat1auth,1)),...
            ' events in ',cat1.name,' are missing from ',cat2.name,' and are ',cat1.auth,' authoritative in ',cat1.name,' (',...
            num2str(size(missing.cat1auth,1)/size(missing.cat1,1)*100),'% of ',cat1.name,' missing events)']);
        disp(' ')
    end
    if ~isempty(missing.cat1nonauth) %Non-authoritative in Cat1 but missing from Cat2
        disp([num2str(size(missing.cat1nonauth,1)),...
            ' events in ',cat1.name,' are missing from ',cat2.name,' and are not',cat1.auth,' authoritative in ',cat1.name,' (',...
            num2str(size(missing.cat1nonauth,1)/size(missing.cat1,1)*100),'% of ',cat1.name,' missing events)']);
        disp(' ')
    end
    if ~isempty(missing.cat2auth)
        disp([num2str(size(missing.cat2auth,1)),...
            ' events in ',cat2.name,' are missing from ',cat1.name,' and are ',cat1.auth,' authoritative in ',cat2.name,' (',...
            num2str(size(missing.cat2auth,1)/size(missing.cat2,1)*100),'% of ',cat2.name,' missing events)']);        
    end
    if ~isempty(missing.cat2nonauth)
        disp([num2str(size(missing.cat2nonauth,1)),...
            ' events in ',cat2.name,' are missing from ',cat1.name,' and are not ',cat1.auth,' authoritative in ',cat2.name,' (',...
            num2str(size(missing.cat2nonauth,1)/size(missing.cat2,1)*100),'% of ',cat2.name,' missing events)']);
        disp(' ')
    end
end
%
% Save files
%
fpath = strcat(pwd,'/',outputDir);
writetable(matching.cat1,strcat(fpath,'/Matching_CAT1.csv'))
writetable(matching.cat2,strcat(fpath,'/Matching_CAT2.csv'))
writetable(missing.cat1,strcat(fpath,'/Missing_CAT1.csv'))
writetable(missing.cat2,strcat(fpath,'/Missing_CAT2.csv'))
disp(' ')
disp(['***CSV FILES OF MATCHING AND MISSING EVENTS AVAILABLE IN', fpath,'***'])
%
% End of Function
%
end
    
