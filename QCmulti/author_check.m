function [auth, orphan] = author_check(matching)
%
% Function that checks the authoritative IDs of matching events
%
% Input: matching - data structure of matching events from compareevnts
%
% Output: auth - data structure of matching authoritative events
%         orphan - data structure of matching events with different event
%         IDs
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Counters, variables, and formatting
%
A = 0;
O = 0;
FormatSpec1 = '%-20s %-20s %-8s %-9s %-7s %-7s %-7s %-7s %-7s %-7s\n';
FormatSpec2 = '%-20s %-20s %-8s %-9s %-7s %-7s \n';
auth.data=[];auth.data2=[];auth.ids=[];
orphan.data=[];orphan.data2=[];orphan.ids=[];
%
%Check matching events
%
for ii = 1 : size(matching.data,1)
    if strcmpi(matching.ids{ii,1},matching.ids{ii,2})
        A=A+1;
        auth.data(A,:) = matching.data(ii,:);
        auth.data2(A,:) = matching.data2(ii,:);
        auth.ids{A,1} = matching.ids{ii,1};
        auth.ids{A,2} = matching.ids{ii,2};
    else
        O = O+1;
        orphan.data(O,:) = matching.data(ii,:);
        orphan.data2(O,:) = matching.data2(ii,:);
        orphan.ids{O,1} = matching.ids{ii,1};
        orphan.ids{O,2} = matching.ids{ii,2};
    end
end
%
%Display summary
%
%% _Summary_
if ~isempty(auth.data)
    disp([num2str(size(auth.data,1)),' -- Matching Authoritative Events (',num2str(size(auth.data,1)/size(matching.data,1)*100),'%)'])
end
    disp(' ')
if ~isempty(orphan.data)
    disp([num2str(size(orphan.data,1)),'-- Orphan Events (',num2str(size(orphan.data,1)/size(matching.data,1)*100),'%)'])
end
for ii = 1 : size(orphan.data,1)
	fprintf(FormatSpec1,orphan.ids{ii,1}, datestr(orphan.data(ii,1),'yyyy/mm/dd HH:MM:SS'),...
        num2str(orphan.data(ii,2)),num2str(orphan.data(ii,3)),num2str(orphan.data(ii,4)),...
        num2str(orphan.data(ii,5)),num2str(orphan.data(ii,6)), num2str(orphan.data(ii,7)),...
        num2str(orphan.data(ii,8)),num2str(orphan.data(ii,9)));
	fprintf(FormatSpec2,orphan.ids{ii,2}, datestr(orphan.data2(ii,1),'yyyy/mm/dd HH:MM:SS'),...
        num2str(orphan.data2(ii,2)),num2str(orphan.data2(ii,3)),num2str(orphan.data2(ii,4)),...
        num2str(orphan.data2(ii,5)));
	disp('----')
end
%
% End of function
%
end
