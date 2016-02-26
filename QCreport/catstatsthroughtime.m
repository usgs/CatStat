function catstatsthroughtime(eqevents)
%
% Remove NaN
%
eqevents(isnan(eqevents(:,5)),:) = [];
%
% Required variables
%
MagBin = 0.01;
McCorr = 0.3;
%
% Time Span of the catalog
%
begYear = str2double(datestr(eqevents(1,1),'yyyy'));
endYear = str2double(datestr(eqevents(end,1),'yyyy'));
timeSpan = endYear - begYear;
%
% Yearly Bins
%
timeBins = linspace(begYear,endYear,timeSpan);
%
% Get M_c and B-value
%
for ii = 1 : length(timeBins)-1
    tmpBegYear = datenum(num2str(timeBins(ii)),'yyyy');
    tmpEndYear = datenum(num2str(timeBins(ii+1)),'yyyy');
    ind = find(eqevents(:,1) >= tmpBegYear & eqevents(:,1) < tmpEndYear);
    if isempty(ind)
        pause
    end
    Mags = eqevents(ind,5);
    [Mc(ii),magVec,bins] = Mc_maxcurve(Mags,MagBin,McCorr);
    [bvalue(ii),~,~,std_err(ii),~] = bval_maxlike(magVec,bins);
    [bvalue2(ii),~,~,std_err2(ii),~] = bval_lstsq(magVec,MagBin,bins);
end
%
% Figure
%
figure;clf
subplot(3,1,1)
plot(timeBins(1:end-1),Mc,'-')
hold on
axis([timeBins(1), timeBins(end-1), 0.5, 5])
title('M_{c} through time')
ylabel('Magnitude of Completion')
hold off
set(gca,'FontSize',14)
subplot(3,1,2)
plot(timeBins(1:end-1),bvalue,'-')
hold on
plot(timeBins(1:end-1),bvalue+std_err,'k--')
plot(timeBins(1:end-1),bvalue-std_err,'k--')
plot(timeBins(1:end-1),ones(1,length(timeBins)-1),'r')
axis([timeBins(1), timeBins(end-1),0,2])
title('B-value through time -- Maximum Likelihood (1 year bins)')
ylabel('B-value')
xlabel('Date (year)')
set(gca,'FontSize',14)
hold off
subplot(3,1,3)
plot(timeBins(1:end-1),bvalue2,'-')
hold on
plot(timeBins(1:end-1),bvalue2+std_err2,'k--')
plot(timeBins(1:end-1),bvalue2-std_err2,'k--')
plot(timeBins(1:end-1),ones(1,length(timeBins)-1),'r')
axis([timeBins(1), timeBins(end-1),0,2])
title('B-value through time -- Least Squares (1 year bins)')
ylabel('B-value')
xlabel('Date (year)')
set(gca,'FontSize',14)
hold off
drawnow
end