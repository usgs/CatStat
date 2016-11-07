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
Dmin = min([matching.cat1.OriginTime;matching.cat2.OriginTime]);
Dmax = max([matching.cat1.OriginTime;matching.cat2.OriginTime]);
% OT Residuals
Tmin = min(matching.cat1.delTime)*86400;
Tmx = max(matching.cat1.delTime)*86400;
Tmax = max([abs(Tmin);Tmx]);
% Location Residuals
DistMax = max(matching.cat1.delD);
if DistMax == 0
    DistMax = 1;
end
% Depth Residuals
Depmin = min(matching.cat1.delDepth);
Depmx = max(matching.cat1.delDepth);
Depmax = max([abs(Depmin),Depmx]);
if Depmax == 0;
    Depmax = 1;
end
% Magnitude Residuals
Magmin = min(matching.cat1.delMag);
Magmx = max(matching.cat1.delMag);
MagMax = max([abs(Magmin), Magmx]);
%
% Initialize figure
%%
figure('Position',[500 500 750 750])
%
% Subplot 1: Time residuals
%
subplot(4,1,1)
plot(matching.cat1.OriginTime, matching.cat1.delTime.*86400,'k.')
%
% Formatting
%
datetick('x','yyyy-mm-dd')
title(sprintf([cat1name,' - ',cat2name,'\nOrigin Time Residuals']))
if Tmax == 0
    axis([Dmin Dmax -1 1])
else
    axis([Dmin Dmax -1*Tmax Tmax])
end
ylabel('Time (s)')
set(gca,'FontSize',14)
%
% Subplot 2: Location Residuals
%
subplot(4,1,2)
plot(matching.cat1.OriginTime, matching.cat1.delD,'k.')
%
% Formatting
%
datetick('x','yyyy-mm-dd')
title('Location Residuals')
axis([Dmin Dmax 0 DistMax])
ylabel('Distance (km)')
set(gca,'FontSize',14)
%
% Subplot 3: Depth Residuals
%
subplot(4,1,3)
plot(matching.cat1.OriginTime, matching.cat1.delDepth,'k.')
%
% Formatting
%
datetick('x','yyyy-mm-dd')
axis([Dmin Dmax -1*Depmax Depmax])
title('Depth Residuals')
ylabel('Depth (km)')
set(gca,'FontSize',14)
%
% Subplot 4: Magnitude Residuals
%
subplot(4,1,4)
plot(matching.cat1.OriginTime, matching.cat1.delMag,'k.')
%
% Formatting
%
datetick('x','yyyy-mm-dd')
if MagMax == 0
    axis([Dmin Dmax -1 1])
else
    axis([Dmin Dmax -1*MagMax MagMax])
end
    
title('Magnitude Residuals')
ylabel('Magnitude')
xlabel('Date')
set(gca,'FontSize',14)
%
% End of Function
%
end