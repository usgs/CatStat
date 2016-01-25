function [missing, dist, dep, mags, both, matching] = compareevnts(cat1,cat2,tmax,delmax,magdelmax,depdelmax)
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
DD=0;
Q=0;
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
% Matching is all but depth empty arrays and counter
%
D=0;
dep.events1 = []; dep.events2 = []; dep.ids= []; dep.type = [];
%
% Matching in all but magnitude empty arrays and counter
%
G = 0;
mags.events1 = []; mags.events2 = []; mags.ids = []; mags.type = [];
%
% Matching but depth and magnitude are out of tolerance empty arrays and counter
%
B = 0;
both.events1 = []; both.events2 = []; both.ids = []; both.types = [];
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
            depdif = cat1.data(ii,4) - timematch(jj,4);
            magdif = cat1.data(ii,5) - timematch(jj,5);
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
                % We have a good match
                %
                M=M+1;
                row = [cat1.data(ii,:),mindist, depdif, magdif,cat1.data(ii,1)-timematch(jj,1)];
                matching.data(M,:) = row;
                matching.data2(M,:) = cat2.data(ind,:);
                matching.ids{M,1} = char(cat1.id{ii,1});
                matching.ids{M,2} = char(cat2.id{ind,1});
            end
            %
            % If locations are similar, determine depth and magnitude residuals
            %
            if(abs(depdif) > depdelmax && abs(magdif) <= magdelmax)
                %
                % If the depth residual is too great, but mag res in tolerance
                %
                D=D+1;
                dep.events1 = [dep.events1;[cat1.data(ii,:),depdif]];
                dep.events2 = [dep.events2;cat2.data(ind,:)];
                dep.ids{D,1} = char(cat1.id{ii,:});
                dep.ids{D,2} = char(cat2.id{ind,:});
                dep.type = [dep.type;cat1.evtype(ii,:)];
            elseif(abs(magdif) > magdelmax && abs(depdif)<=depdelmax)
                %
                % If magnitude residual is too great, but dep red in tolerance
                %
                G=G+1;
                mags.events1 = [mags.events1;cat1.data(ii,:),magdif];
                mags.events2 = [mags.events2;cat2.data(ind,:)];
                mags.ids{G,1} = char(cat1.id{ii,1});
                mags.ids{G,2} = char(cat2.id{ind,1});
                mags.type = [mags.type;cat1.evtype(ii,:)];
            elseif(abs(magdif) > magdelmax && abs(depdif) > depdelmax)
                %
                % If both mag res and dep res out of tolerance
                %
                B=B+1;
                both.events1 = [both.events1;cat1.data(ii,:),depdif,magdif];
                both.events2 = [both.events2;cat2.data(ind,:)];
                both.ids{B,1} = char(cat1.id{ii,1});
                both.ids{B,2} = char(cat2.id{ind,1});
                both.types = [both.types;cat1.evtype(ii,:)];
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
else
end
if ~isempty(mags.events1)
	disp([num2str(G),' events matched in origin time, location and depth, but magnitude residuals were greater than ',num2str(magdelmax),'.']);
else
if ~isempty(both.events1)
	disp([num2str(B),' events matched in origin time and location, but magnitude and depth residuals were greater than ',num2str(magdelmax),' and ',num2str(depdelmax),' km, respectively.']);
else
end
disp(' ')
%
%Possible Duplicate Events
%
if length(cat1.data(:,1)) < m1+d+M || length(cat2.data(:,1)) < m+d+M
    disp('   ----------------- POSSIBLE DUPLICATE EVENTS ----------------')
    disp('POSSIBLE DUPLICATE EVENTS')
    disp([' '])
end
%
%End of function
%
end
