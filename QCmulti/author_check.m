function author_check(cat1, auth_cat1, non_auth_cat1,nonauth_matching,...
    nonauth_missing,matching,tmax,delmax)
%
% Function that checks the authoritative IDs of matching events
%
% Input: cat1 - data structure of catalog 1 (ComCat)
%        auth_cat1 - Number of regional authoritative events in first catalog
%        non_auth_cat1 - Number of non-regional authoritative events in the
%        first catalog.
%        nonauth_matching - structure of matching events that have
%        non-authoritative events in catalog 1
%        nonauth_missing - structure of events missing from catalog 2 that
%        have non-authoritative events in catalog 1
%        matching - data structure of matching events
%        tmax - Time window
%        delmax - distance window
%
% Output: auth - data structure of matching authoritative events
%         orphan - data structure of matching events with different event
%         IDs
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Counters, variables, and formatting
%
FormatSpec1 = '%-20s %-20s %-8s %-9s %-7s %-7s %-7s %-7s %-7s %-7s\n';
FormatSpec2 = '%-20s %-20s %-8s %-9s %-7s %-7s \n';
%
%
%
if ~isempty(auth_cat1)
disp([num2str(size(auth_cat1,1)),' events are authoritative in ', ...
    cat1.name,', thus have matching IDs (',...
    num2str(size(auth_cat1,1)/size(matching.data,1)*100),'%)'])
end
disp(' ')
if ~isempty(non_auth_cat1)
disp([num2str(size(non_auth_cat1,1)),' events in ', ...
    cat1.name,' come from non-authoritative networks (',...
    num2str(size(non_auth_cat1,1)/size(matching.data,1)*100),'%)'])
end
disp(' ')
if ~isempty(nonauth_matching.ids)
disp([num2str(size(nonauth_matching.ids,1)),' of the ',num2str(size(non_auth_cat1,1)),...
    ' events from non-authoritative networks match within ',num2str(tmax),' s and ',num2str(delmax),' km.'])
disp(' ')
for ii = 1 : size(nonauth_matching.ids,1)
fprintf(FormatSpec1,nonauth_matching.ids{ii,1}, datestr(nonauth_matching.data(ii,1),'yyyy/mm/dd HH:MM:SS'),...
        num2str(nonauth_matching.data(ii,2)),num2str(nonauth_matching.data(ii,3)),num2str(nonauth_matching.data(ii,4)),...
        num2str(nonauth_matching.data(ii,5)),num2str(nonauth_matching.data(ii,6)), num2str(nonauth_matching.data(ii,7)),...
        num2str(nonauth_matching.data(ii,8)),num2str(nonauth_matching.data(ii,9)));
	fprintf(FormatSpec2,nonauth_matching.ids{ii,2}, datestr(nonauth_matching.data2(ii,1),'yyyy/mm/dd HH:MM:SS'),...
        num2str(nonauth_matching.data2(ii,2)),num2str(nonauth_matching.data2(ii,3)),num2str(nonauth_matching.data2(ii,4)),...
        num2str(nonauth_matching.data2(ii,5)));
	disp('----')
end
end
disp(' ')
if ~isempty(nonauth_missing.ids)
disp([num2str(size(nonauth_missing.ids,1)),' of the ',num2str(size(non_auth_cat1,1)),...
    ' event from the non-authoritatice networks have no match within ',num2str(tmax),' s and ',num2str(delmax),' km.'])
disp(' ')
for ii = 1 : size(nonauth_missing.ids,1)
	fprintf(FormatSpec2,nonauth_missing.ids{ii,1}, datestr(nonauth_missing.data(ii,1),'yyyy/mm/dd HH:MM:SS'),...
        num2str(nonauth_missing.data(ii,2)),num2str(nonauth_missing.data(ii,3)),num2str(nonauth_missing.data(ii,4)),...
        num2str(nonauth_missing.data(ii,5)));
	disp('----')
end
end
end
