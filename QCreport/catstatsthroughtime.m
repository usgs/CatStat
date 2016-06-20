function catstatsthroughtime(eqevents)
%
% Remove NaN
%
eqevents(isnan(eqevents(:,5)),:) = [];
%
% Required variables
%
MagBin = 0.1;
McCorr = 0.3;
%
% Time Span of the catalog
%
begYear = str2double(datestr(eqevents(1,1),'yyyy'));
endYear = str2double(datestr(eqevents(end,1),'yyyy'));
timeSpan = (endYear - begYear)*2;
tmpBegYear = datenum([num2str(begYear),'-01-01'],'yyyy-mm-dd');
tmpEndYear = tmpBegYear + 365*5; %Jump a year
binYearCount = 0;
while tmpEndYear <= datenum([num2str(endYear),'-12-31'],'yyyy-mm-dd');
    Mags = [];
    Mags_evolve = [];
    binYearCount = binYearCount+1;
    timeBins(binYearCount) = tmpBegYear;
    %
    % Get yearly B-value
    %
    ind = find(eqevents(:,1) >= tmpBegYear & eqevents(:,1) <= tmpEndYear);
    Mags = eqevents(ind,5);
    Mc(binYearCount) = Mc_maxcurve(Mags,MagBin,McCorr);
    Mags = Mags(Mags >= Mc(binYearCount),:);
    [bvalue(binYearCount),~,~,~,std_dev(binYearCount)] = bval_maxlike(Mc(binYearCount),Mags,MagBin);
    %
    % Get evolving b-value
    %
    ind_evolve = find(eqevents(:,1) >= timeBins(1) & eqevents(:,1) <= tmpEndYear);
    Mags_evolve = eqevents(ind_evolve,5);
    Mc_evolve(binYearCount) = Mc_maxcurve(Mags_evolve,MagBin,McCorr);
    [bvalue_evolve(binYearCount),~,~,~,std_dev_evolve(binYearCount)] = ...
        bval_maxlike(Mc_evolve(binYearCount),Mags_evolve,MagBin);
    tmpBegYear = tmpBegYear + 182.5; % Half a year step
    tmpEndYear = tmpBegYear + 365*5; % jump a year
end
%
% Initialize figures
%
figure;clf
%
% Mc through time
%
subplot(2,2,1)
plot(timeBins,Mc,'k-')
hold on
datetick('x','yyyy')
axis([timeBins(1), timeBins(end), 0.5, 10])
title('M_{c} through time -- 5 year bins')
ylabel('Magnitude of Completion')
hold off
set(gca,'FontSize',14)
%
% Mc evolution through time
%
subplot(2,2,2)
plot(timeBins,Mc_evolve,'k-')
hold on
datetick('x','yyyy')
axis([timeBins(1), timeBins(end), 0.5, 10])
title('M_{c} evolution through time')
ylabel('Magnitude of Completion')
hold off
set(gca,'FontSize',14)
%
% B-value through time
%
subplot(2,2,3)
plot(timeBins,bvalue,'-')
hold on
plot(timeBins,bvalue+std_dev,'k--')
plot(timeBins,bvalue-std_dev,'k--')
plot(timeBins,ones(1,length(timeBins)),'r')
datetick('x','yyyy')
axis([timeBins(1), timeBins(end),0,2])
title('B-value through time -- 5 year bins')
ylabel('B-value')
xlabel('Date (year)')
set(gca,'FontSize',14)
hold off
drawnow
%
% B-value evolution through time
%
subplot(2,2,4)
plot(timeBins,bvalue_evolve,'-')
hold on
plot(timeBins,bvalue_evolve+std_dev_evolve,'k--')
plot(timeBins,bvalue_evolve-std_dev_evolve,'k--')
plot(timeBins,ones(1,length(timeBins)),'r')
datetick('x','yyyy')
axis([timeBins(1), timeBins(end),0,2])
title('B-value Evolution')
ylabel('B-value')
xlabel('Date (year)')
set(gca,'FontSize',14)
hold off
drawnow
end