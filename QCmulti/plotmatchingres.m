function plotmatchingres(matching,cat1name,cat2name)
%
% This function plots the residuals of the Origin time, location, depth,
% and magnitude as a function of time.
%
% Input: Matching - data structure for matching events
%        cat1name - name of catalog 1
%        cat2name - name of catalog 2
%
% Output - None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get bounds
%
% Time
Dmin = min(matching.data(:,1));
Dmax = max(matching.data(:,1));
% OT Residuals
Tmin = min(matching.data(:,9))*86400;
Tmx = max(matching.data(:,9))*86400;
Tmax = max([abs(Tmin),Tmx]);
% Location Residuals
DistMax = max(matching.data(:,6));
% Depth Residuals
Depmin = min(matching.data(:,7));
Depmx = max(matching.data(:,7));
Depmax = max([abs(Depmin),Depmx]);
% Magnitude Residuals
Magmin = min(matching.data(:,8));
Magmx = max(matching.data(:,8));
MagMax = max([abs(Magmin), Magmx]);
%
% Initialize figure
%%
figure('Position',[500 500 750 750])
%
% Subplot 1: Time residuals
%
subplot(4,1,1)
plot(matching.data(:,1), matching.data(:,9)*86400,'k.')
%
% Formatting
%
datetick('x','yyyy-mm-dd')
title(sprintf([cat1name,' - ',cat2name,'\nOrigin Time Residuals']))
axis([Dmin Dmax -1*Tmax Tmax])
set(gca,'FontSize',14)
%
% Subplot 2: Location Residuals
%
subplot(4,1,2)
plot(matching.data(:,1), matching.data(:,6),'k.')
%
% Formatting
%
datetick('x','yyyy-mm-dd')
title('Location Residuals')
axis([Dmin Dmax 0 DistMax])
set(gca,'FontSize',14)
%
% Subplot 3: Depth Residuals
%
subplot(4,1,3)
plot(matching.data(:,1), matching.data(:,7),'k.')
%
% Formatting
%
datetick('x','yyyy-mm-dd')
axis([Dmin Dmax -1*Depmax Depmax])
title('Depth Residuals')
set(gca,'FontSize',14)
%
% Subplot 4: Magnitude Residuals
%
subplot(4,1,4)
plot(matching.data(:,1), matching.data(:,8),'k.')
%
% Formatting
%
datetick('x','yyyy-mm-dd')
axis([Dmin Dmax -1*MagMax MagMax])
title('Magnitude Residuals')
set(gca,'FontSize',14)
%
% End of Function
%
end