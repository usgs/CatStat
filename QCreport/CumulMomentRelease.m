function CumulMomentRelease(EQEvents,name)
%
% Remove NaN
%
EQEvents(isnan(EQEvents.Mag),:) = [];
EQEvents(EQEvents.Mag==0,:) = [];
%
% Calculate moment release for each event
%
M0 = 10.^((3/2).*(EQEvents.Mag+10.7));
M0 = M0.*10^-7; % Convert to N*m from dyne * cm <- dumb units
cumul_M0 = cumsum(M0);
%
% Get Largest Events
%
%
% Initialize Figure
%
figure;clf
%
% Plot
%
plot(EQEvents.OriginTime,cumul_M0,'k-')
hold on
largestnum = 5;
[~,ii] = sortrows(EQEvents,find(strcmp('Mag',fields(EQEvents))));
eqevents_sort = EQEvents(ii,:);
for jj = size(EQEvents,1):-1:size(EQEvents,1)-largestnum-1
     plot([eqevents_sort.OriginTime(jj), eqevents_sort.OriginTime(jj)],...
         [min(cumul_M0), max(cumul_M0)],'--')
end
%
% Format options
%
datetick('x','yyyy')
ylabel('Cumulative Moment Release (N*m)')
xlabel('Year')
title(sprintf('Cumulative Moment Release \n as Recorded by the %s catalog\n',name))
set(gca,'FontSize',14)
set(gca,'XTickLabelRotation',45)
%legend(hh1,[datestr(eqevents_sort(1,1),'yyyy-mm-dd'),' M',num2str(eqevents_sort(1,5))])
drawnow
end
