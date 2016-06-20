function CumulMomentRelease(eqevents,name,trig)
%
% Remove NaN
%
eqevents(isnan(eqevents(:,5)),:) = [];
eqevents(eqevents(:,5)==0,:) = [];
%
% Calculate moment release for each event
%
M0 = 10.^((3/2).*(eqevents(:,5)+10.7));
M0 = M0.*10^-7; % Convert to N*m from dyne * cm <- dumb units
cumul_M0 = cumsum(M0);
%
% Get Largest Events
%

if trig==1
    %
    % Initialize Figure
    %
    figure(1);clf
    %
    % Plot
    %
    plot(eqevents(:,1),cumul_M0,'k-')
    hold on
    largestnum = 5;
    [nn,ii] = sortrows(eqevents,5);
    eqevents_sort = eqevents(ii,:);
    for jj = length(nn):-1:length(nn)-largestnum-1
         plot([eqevents_sort(jj,1), eqevents_sort(jj,1)],...
             [min(cumul_M0), max(cumul_M0)],'--')
    end
    %
    % Format options
    %
    datetick('x','yyyy')
    ylabel('Cumulative Moment Release (N*m)')
    xlabel('Year')
    title(sprintf('Cumulative Moment Release \n as Recorded by the %s catalog',name))
    set(gca,'FontSize',14)
    %legend(hh1,[datestr(eqevents_sort(1,1),'yyyy-mm-dd'),' M',num2str(eqevents_sort(1,5))])
    drawnow
end
end
