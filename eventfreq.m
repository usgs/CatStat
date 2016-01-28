function eventfreq(eqevents,sizenum)
% This function plots and compares event frequency over the entire catalog. 
% Input: 
%       eqevents - Earthquake events from catalog
%       sizenum - plotting option determined in catalogsize
%
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
disp(['Frequency of EARTHQUAKE EVENTS ONLY. All other event types ignored.']);
%
% Initialize Figure
%
figure
hold on
histogram(eqevents(:,1),eqevents(1,1)-0.5:1:max(eqevents(:,1))-0.5)
%
% Format Options
% 
set(gca,'fontsize',15)
title('Events per Day','fontsize',18)
ylabel('Number of Events','fontsize',18)
if sizenum == 1
    datetick
    xlabel('Years','fontsize',18)
elseif sizenum == 2
    datetick('x','mmmyy')
    xlabel('Month-Year','fontsize',18)
else
    datetick('x','mm-dd-yy')
    xlabel('Month-Day-Year','fontsize',18)
end
axis tight;
hold off
drawnow
%
% End of Function
%
end