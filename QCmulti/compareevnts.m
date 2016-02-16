function [missing, dist, dep, mags, both, matching] ...
    = compareevnts(cat1,cat2,tmax,delmax,magdelmax,depdelmax)
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
% Begin function
%
% Useful variables
%
sec_per_day = 86400;
%
% Convert Time window
%
tmax = tmax/sec_per_day;
time_window =1*24*60*60; %1 day time window
time_window = time_window/sec_per_day;
%
% Empty matrices
%
missing.events1 = []; missing.ids1 = []; missing.type1=[];
missing.events2 = []; missing.ids2 = []; missing.type2=[];
dist.events1 = []; dist.ids1 = []; dist.type1 = [];
dist.events2 = []; dist.ids2 = []; dist.type2 = [];
dep.events1 = []; dep.events2 = []; dep.ids= []; dep.type = [];
mags.events1 = []; mags.events2 = []; mags.ids = []; mags.type = [];
both.events1 = []; both.events2 = []; both.ids = []; both.types = [];
matching.data =[]; matching.data2 = []; matching.ids = [];
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
% Compare catalog 1 events with catalog 2 events
%
for ii = 1 : length(cat1.data)
    %
    % Find those events within 15 minutes
    %
    cat2_ind = find(abs((cat1.data(ii,1)-cat2.data(:,1)))<=time_window);
    %
    clear C;
    C(:,1) = (cat1.data(ii,1)-cat2.data(cat2_ind,1))./tmax;
    C(:,2) = distance_hvrsn(cat1.data(ii,2),cat1.data(ii,3),cat2.data(cat2_ind,2),cat2.data(cat2_ind,3))./delmax;
    C(:,3) = (cat1.data(ii,4) - cat2.data(cat2_ind,4))./depdelmax;
    C(:,4) = (cat1.data(ii,5) - cat2.data(cat2_ind,5))./magdelmax;
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
        missing.events1(m,:) = cat1.data(ii,:);
        missing.ids1{m,1} = char(cat1.id{ii,1});
    elseif abs(C(ind,1)) > 1
        m=m+1;
        missing.events1(m,:) = cat1.data(ii,:);
        missing.ids1{m,1} = char(cat1.id{ii,1});
    %
    % If time match, check distance
    %
    elseif abs(C(ind,1)) <= 1 && C(ind,2) > 1
        d=d+1;
        dist.events1(d,:) = [cat1.data(ii,:),C(ind,2)*delmax];
        dist.events2(d,:) = cat2.data(EOI,:);
        dist.ids1{d,1} = char(cat1.id{ii,:});
        dist.ids1{d,2} = char(cat2.id{EOI,:});
    else
    %
    % If both time and distance are within tolerance, we have a match
    %
        M=M+1;
        row = [cat1.data(ii,:),C(ind,2)*delmax,C(ind,3)*depdelmax,C(ind,4)*magdelmax,C(ind,1)*tmax*sec_per_day];
        matching.data(M,:) = row;
        matching.data2(M,:) = cat2.data(EOI,:);
        matching.ids{M,1} = char(cat1.id{ii,1});
        matching.ids{M,2} = char(cat2.id{EOI,1});
        %
        % Now check matching events for differences in depth and
        % magnitude
        %
        if abs(C(ind, 3)) > 1 & abs(C(ind,4)) <= 1
            D=D+1;
            dep.events1(D,:) = [cat1.data(ii,:),C(ind,3)*depdelmax];
            dep.events2(D,:) = cat2.data(EOI,:);
            dep.ids{D,1} = char(cat1.id{ii,:});
            dep.ids{D,2} = char(cat2.id{EOI});
            %dep.type = [dep.type; char(cat1.evtype(ii,:))];
        elseif abs(C(ind, 3)) <= 1 && abs(C(ind,4)) > 1
            %
            % If magnitude residual is too great, but dep red in tolerance
            %
            G=G+1;
            mags.events1(G,:) = [cat1.data(ii,:),C(ind,4)*magdelmax];
            mags.events2(G,:) = cat2.data(EOI,:);
            mags.ids{G,1} = char(cat1.id{ii,1});
            mags.ids{G,2} = char(cat2.id{EOI,1});
            %mags.type = [mags.type; char(cat1.evtype(ii,:))];
        elseif abs(C(ind, 3)) > 1 && abs(C(ind, 4)) > 1
            %
            % If both mag res and dep res out of tolerance
            %
            B=B+1;
            both.events1(B,:) = [cat1.data(ii,:),C(ind,3)*depdelmax,C(ind,4)*magdelmax];
            both.events2(B,:) = (cat2.data(EOI,:));
            both.ids{B,1} = char(cat1.id{ii,1});
            both.ids{B,2} = char(cat2.id{EOI,1});
            %both.type = [both.type; char(cat1.evtype(ii,:))];
        end
    end
end
%
% Events in catalog 1 that matched in time and were separated due to
% whether or not matching criteria were met will be the same as those is
% catalog 2 that matched in time.  Therefore, it is unnecessary to run all
% events in catalog 2 through all matching criteria.  
%
% Number of catalog 1 events missing from catalog 2.  Save for output
%
m1=m; % Save number of missing and restart counter
m = 0;
C = [];
%
% Compare catalog 2 events with catalog 1 events
%
for ii = 1 : length(cat2.data)
    %
    % Find those events within 15 minutes
    %
    cat1_ind = find(abs((cat2.data(ii,1)-cat1.data(:,1)))<=time_window);
    %
    clear C;
    C(:,1) = (cat2.data(ii,1)-cat1.data(cat1_ind,1))./tmax;
    C(:,2) = distance_hvrsn(cat1.data(cat1_ind,2),cat1.data(cat1_ind,3),cat2.data(ii,2),cat2.data(ii,3))./delmax;
    C(:,3) = (cat2.data(ii,4) - cat1.data(cat1_ind,4))./depdelmax;
    C(:,4) = (cat2.data(ii,5) - cat1.data(cat1_ind,5))./magdelmax;
    %
    % Minimize L2 norm of each row
    %
    [~,ind] = min(sqrt(sum(abs(C).^2,2)));
    %
    % Event of Interest row index in catalog 2
    %
    EOI = cat1_ind(ind);
    %
    % Check to make sure C(ind,1)
    %
    if isempty(C)
        m=m+1;
        missing.events2(m,:) = cat2.data(ii,:);
        missing.ids2{m,1} = char(cat2.id{ii,1});
    elseif abs(C(ind,1)) > 1
        m=m+1;
        missing.events2(m,:) = cat2.data(ii,:);
        missing.ids2{m,1} = char(cat2.id{ii,1});
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Summary Information
%
disp('-- Number of events after filtering --')
disp([num2str(length(cat1.data(:,1))),' ',cat1.name,' events in the target region.'])
disp([num2str(length(cat2.data(:,1))),' ',cat2.name,' events in the target region.'])
disp(' ')
%
%Matching Events
%
disp('      ---------------- MATCHING EVENTS ----------------    ')
if ~isempty(matching.data)
    disp([num2str(M),' ',cat1.name,' and ',cat2.name, ' meet matching criteria.'])
else
    disp('No matching events')
end
disp(' ')
%
%Missing Events
%
disp('   -------------------- MISSING EVENTS --------------------   ')
disp(' ')
disp('                  ---Total Missing Events---')
disp(['There are ',num2str(size(missing.events1,1)+size(dist.events1,1)),' event(s) in ',cat1.name])
disp(['missing from ',cat2.name])
disp(['There are ',num2str(size(missing.events2,1)+size(dist.events2,1)),' event(s) in ',cat2.name])
disp(['missing from ',cat1.name])
disp(' ')
disp('---- No Similar Origin Times ----')
if ~isempty(missing.events1)
    disp([num2str(m1),' event(s) in ', cat1.name, ' have origin times not in ', cat2.name])
else
    disp(['0 event(s) in ',cat1.name, ' have origin time not in ', cat2.name])
end
if ~isempty(missing.events2)
    disp([num2str(m), ' event(s) in ', cat2.name, ' have origin times not in ', cat1.name])
	disp(' ')
else
    disp(['0 event(s) in ',cat2.name, ' have origin time not in ', cat1.name])
	disp(' ')
end
%
%Locations not similar
%
if ~isempty(dist.events1)
	disp('---- Match in time but NOT location ----')
	disp([num2str(d),' events matched in time but location differences were greater than ',num2str(delmax),' km apart']);
end
disp(' ')
%
%Matching events that have possible data errors
%
disp(['-------------------- POSSIBLE PROBLEM EVENTS ---------------    '])
if ~isempty(dep.events1)
	disp([num2str(D),' events matched origin time, location, and magnitude, but depths were greater than ',num2str(depdelmax),' km apart']);
end
if ~isempty(mags.events1)
	disp([num2str(G),' events matched in origin time, location and depth, but magnitude residuals were greater than ',num2str(magdelmax),'.']);
end
if ~isempty(both.events1)
	disp([num2str(B),' events matched in origin time and location, but magnitude and depth residuals were greater than ',num2str(magdelmax),' and ',num2str(depdelmax),' km, respectively.']);
end
disp(' ')
%
%Possible Duplicate Events
%
FormatSpec1 = '%-20s %-20s %-8s %-9s %-7s %-7s %-7s %-7s %-7s %-7s\n';
FormatSpec2 = '%-20s %-20s %-8s %-9s %-7s %-7s \n';
if length(cat1.data(:,1)) < m1+d+M || length(cat2.data(:,1)) < m+d+M
    disp('--------MULTIPLE EVENT MATCHES-----------')
    disp('')
    %
    % Check for unique IDs in catalog 1
    %
    [~,uniqueIdx1] = unique(matching.ids(:,1));
    dups1 = matching.ids(:,1);
    dups1(uniqueIdx1) = [];
    dups1 = unique(dups1);
    if ~isempty(dups1)
        disp(['Multiple matches in ',cat1.name,' with events in ',cat2.name,'--------'])
        fprintf(FormatSpec1,'Event ID', 'Origin Time','Lat.','Lon.','Dep(km)','Mag','LocRes','DepRes','magRes','TimeRes')
        for ii = 1 : size(dups1,1)
            dups_idx1 = find(strcmpi(dups1(ii,1),matching.ids(:,1)));
            %
            % Only print the duplicate event once
            %
            fprintf(FormatSpec2,matching.ids{dups_idx1(1),1}, datestr(matching.data(dups_idx1(1),1),'yyyy/mm/dd HH:MM:SS'),num2str(matching.data(dups_idx1(1),2)),num2str(matching.data(dups_idx1(1),3)),num2str(matching.data(dups_idx1(1),4)),num2str(matching.data(dups_idx1(1),5)));
            disp('**')
            for jj = 1 : size(dups_idx1)
                %
                % Print the events from catalog 2
                %
                fprintf(FormatSpec1,matching.ids{dups_idx1(jj),2}, datestr(matching.data2(dups_idx1(jj),1),'yyyy/mm/dd HH:MM:SS'),num2str(matching.data2(dups_idx1(jj),2)),num2str(matching.data2(dups_idx1(jj),3)),num2str(matching.data2(dups_idx1(jj),4)),num2str(matching.data2(dups_idx1(jj),5)),num2str(matching.data(dups_idx1(jj),6)),num2str(matching.data(dups_idx1(jj),7)),num2str(matching.data(dups_idx1(jj),8)),num2str(matching.data(dups_idx1(jj),9)));
            end
            disp('--')
        end
    end
    %
    % Repeat for catalog 2 events
    %
    [~,uniqueIdx2] = unique(matching.ids(:,2));
    dups2 = matching.ids(:,1);
    dups2(uniqueIdx2) = [];
    dups2 = unique(dups2);
    if ~isempty(dups2)
        disp(['Multiple matches in ',cat2.name,' with events in ',cat1.name,'--------'])
        fprintf(FormatSpec1,'Event ID', 'Origin Time','Lat.','Lon.','Dep(km)','Mag','LocRes','DepRes','magRes','TimeRes')
        for ii = 1 : size(dups2,1)
            dups_idx2 = find(strcmpi(dups2(ii,1),matching.ids(:,2)));
            %
            % Only print the duplicate event once
            %
            fprintf(FormatSpec2,matching.ids{dups_idx2(1),2}, datestr(matching.data2(dups_idx2(1),1),'yyyy/mm/dd HH:MM:SS'),num2str(matching.data2(dups_idx2(1),2)),num2str(matching.data2(dups_idx2(1),3)),num2str(matching.data2(dups_idx2(1),4)),num2str(matching.data2(dups_idx2(1),5)));
            disp('***')
            for jj = 1 : size(dups_idx2)
                %
                % Print the events from catalog 2
                %
                fprintf(FormatSpec1,matching.ids{dups_idx2(jj),1}, datestr(matching.data(dups_idx2(jj),1),'yyyy/mm/dd HH:MM:SS'),num2str(matching.data(dups_idx2(jj),2)),num2str(matching.data(dups_idx2(jj),3)),num2str(matching.data(dups_idx2(jj),4)),num2str(matching.data(dups_idx2(jj),5)),num2str(matching.data(dups_idx2(jj),6)),num2str(matching.data(dups_idx2(jj),7)),num2str(matching.data(dups_idx2(jj),8)),num2str(matching.data(dups_idx2(jj),9)));
            end
            disp('--')
        end
    end      
end
%
%End of function
%
end
