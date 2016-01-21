function [missing, dist, dep, mags, types, matching] = compareevnts(cat1,cat2,tmax,delmax,magdelmax,depdelmax)
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
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Begin function
%
%
% Convert Time window
%
tmax = tmax/24/60/60;
%
% Missing event empty arrays and counter
%
m=0;
missing.events1 = []; missing.ids1 = []; missing.type1=[];
missing.events2 = []; missing.ids2 = []; missing.type2=[];
%
% Matching only in time empty arrays and counter
%
d=0;
dist.events1 = []; dist.ids1 = []; dist.type1 = [];
dist.events2 = []; dist.ids2 = []; dist.type2 = [];
%
% Matching in time and location but not depth empty arrays and counter
%
D=0;
dep.events1 = []; dep.events2 = []; dep.ids= []; dep.type = [];
%
% Matching in time, location, and depth, but not magnitude empty arrays and counter
%
G = 0;
mags.events1 = []; mags.events2 = []; mags.ids = []; mags.type = [];
%
% Events that match but have different event types empty arrays and counter
% SECTION NOT COMPLETE
%T=0;
types.events = [];%
types.ids = [];
%types.type = [];
% Matching empty arrays and counter
M = 0;
matching.data =[]; matching.data2 = []; matching.ids = [];
%
% Compare catalog 1 events with catalog 2 events
%
for ii = 1:length(cat1.data)
    %
    %Search for origin time matches (within tolerance)
    %
    tdif = abs(cat1.data(ii,1)-cat2.data(:,1));
    timematch = cat2.data(tdif <= tmax,:);
    %
    %If not event is found with similar origin time, the event is marked as
    %missing.
    %
    if(isempty(timematch))
        m=m+1;
        missing.ids1{m,1} = char(cat1.id{ii,1});
        missing.events1 = [missing.events1;cat1.data(ii,:)];
        missing.type1 = [missing.type1;cat1.evtype(ii,:)];
    else
        %
        %If event(s) with similar origin time(s) is (are) found, determine
        %if the locations are similar.
        %
        for jj = 1 : size(timematch,1)
            %
            % Find the index to the matching event(s).
            %
            ind = find(cat2.data(:,1) == timematch(jj,1));
            %
            % Needed catch incase of duplicate events or events very close
            % in time.
            %
            % If there are multiple events that match in time AND more then
            % one index is found
            %
            if size(timematch,1) > 1 && length(ind) > 1
                ind = ind(jj);
                %
                % If index == 1 essentially
                %
            else
                ind = ind;
            end
        %
        % Determine the difference in locations
        %
        [mindist] = distance_hvrsn(cat1.data(ii,2), cat1.data(ii,3),timematch(jj,2),timematch(jj,3));
        %
        % If the locations are too far apart
        %
            if(mindist > delmax)
                d=d+1;
                dist.events1 = [dist.events1;[cat1.data(ii,:),mindist]];
                dist.events2 = [dist.events2;cat2.data(ind,:)];
                dist.ids1{d,1} = char(cat1.id{ii,:});
                dist.ids1{d,2} = char(cat2.id{ind,:});
                dist.type1 = [dist.type1;cat1.evtype(ii,:)];
            else
                %
                % If locations are similar, determine depth residual
                %
                depdif = cat1.data(ii,4) - timematch(jj,4);
                %
                % If the depth residual is too great
                %
                if(abs(depdif) > depdelmax)
                    D=D+1;
                    dep.events1 = [dep.events1;[cat1.data(ii,:),depdif]];
                    dep.events2 = [dep.events2;cat2.data(ind,:)];
                    dep.ids{D,1} = char(cat1.id{ii,:});
                    dep.ids{D,2} = char(cat2.id{ind,:});
                    dep.type = [dep.type;cat1.evtype(ii,:)];
                else
                    %
                    % If depths are similar, determine magnitude residual.
                    %
                    magdif = cat1.data(ii,5) - timematch(jj,5);
                    %
                    % If magnitude residual is too great
                    %
                    if(abs(magdif) > magdelmax)
                        G=G+1;
                        mags.events1 = [mags.events1;cat1.data(ii,:),magdif];
                        mags.events2 = [mags.events2;cat2.data(ind,:)];
                        mags.ids{G,1} = char(cat1.id{ii,1});
                        mags.ids{G,2} = char(cat2.id{ind,1});
                        mags.type = [mags.type;cat1.evtype(ii,:)];
                    else
                        %
                        % If magnitudes are similar, check the event types 
                        % SECTION NOT COMPLETE
                        %
                        %if(strcmpi(cat1.evtype{ii,1},cat2.evtype{cat2.data(:,1) == timematch(1),1})) == 0
                        %
                        %    T=T+1;
                        %    types.ids{T,1} = char(cat1.id{ii,1});
                        %    types.ids{T,2} = char(cat2.id{cat2.data(:,1) == timematch(jj,1),1});
                        %    types.types{T,1} = char(cat1.evtype{ii,1});
                        %    types.types{T,2} = char(cat2.evtype{cat2.data(:,1) == timematch(jj,1),1});
                        %else
                            %
                            % If all criteria are met, the events match
                            %
                            M=M+1;
                            row = [cat1.data(ii,:),mindist, depdif, magdif,cat1.data(ii,1)-timematch(jj,1)];
                            matching.data(M,:) = row;
                            matching.data2(M,:) = cat2.data(ind,:);
                            matching.ids{M,1} = char(cat1.id{ii,1});
                            matching.ids{M,2} = char(cat2.id{ind,1});
                        %end
                    end
                end
            end
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
m1=m;
%
% Compare catalog 2 events with catalog 1 events
%
m=0;
for ii = 1:size(cat2.data,1)
    %
    %Search for origin time matches (within tolerance)
    %
    tdif = abs(cat2.data(ii,1)-cat1.data(:,1));
    timematch = cat1.data(tdif <= tmax,:);
    if(isempty(timematch)) 
        %
        %If there is no time match, record missing event
        %
        m=m+1;
        missing.events2 = [missing.events2;cat2.data(ii,:)];
        missing.ids2{m,1} = char(cat2.id{ii,1});
        missing.type2 = [missing.type2;cat2.evtype(ii,:)];
    end
end
%
% Summary Information
%
disp([' '])
disp(['----- Number of events within the region of interest -----'])
disp([num2str(length(cat1.data(:,1))),' ',cat1.name,' events in the target region.'])
disp([num2str(length(cat2.data(:,1))),' ',cat2.name,' events in the target region.'])
disp(['----- Matching Events -----'])
if ~isempty(matching.data)
    disp([num2str(M),' ',cat1.name,' and ',cat2.name, ' meet matching criteria.'])
else
    disp('No matching events')
end
disp(['----- Matching Criteria Not Met -----'])
if ~isempty(missing.events1)
    disp([num2str(m1+d+D+G),' event(s) in ', cat1.name, ' and not in ', cat2.name])
else
    disp(['0 event(s) in ',cat1.name, ' and not in ', cat2.name])
end
if ~isempty(missing.events2)
    disp([num2str(m+d+D+G), ' event(s) in ', cat2.name, ' and not in ', cat1.name])
else
    disp(['0 event(s) in ',cat2.name, ' and not in ', cat1.name])
end
disp([' '])
if length(cat1.data(:,1)) ~= m1+d+D+G+M || length(cat2.data(:,1)) ~= m+d+D+G+M
    disp('POSSIBLE DUPLICATE EVENTS')
    disp([' '])
end
%
%End of function
%
end