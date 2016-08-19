function catmagcomp(catalog,MagBin,McCorr)
% This function plots and compares the magnitude completeness. 
% Input:
%   catalog - data structure created in loadcat
%   MagBin - binning width e.g. 0.1, 0.05, 0.1 is default
%
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get EQ only
%
eqevents = catalog.data(strncmpi('earthquake',catalog.evtype,10),:);
%
% Display
%
disp(['Magnitude distribution of earthquake events only. All other event types ignored.']);
disp([' ']);
disp(['Cumulative and incremental distributions provide an indication of ']);
disp(['catalog completeness. The max of the incremental distribution is ']);
disp(['generally 0.2 or 0.3 magnitude units smaller than the catalog ']);
disp(['completeness. This completeness estimation is not valid for catalogs ']);
disp(['whose completeness varies in time.']);
disp([' ']);
disp(['Methods for Determining Magnitude of Completeness and B-Value are the '])
disp(['Maximum curvature and maximum likelihood methods, respectively.'])
%
% Determine Magnitude Range
%
minmag = floor(min(eqevents(:,5)));
if minmag > 0
    minmag = 0;
end
maxmag = ceil(max(eqevents(:,5)));
mags = minmag:0.1:maxmag;
cdf = zeros(length(mags),1);
%
% Calculate empirical cumulative magnitude distribution
%
for ii = 1 : length(mags)
    cdf(ii) = sum(round(eqevents(:,5),1,'decimals')>=round(mags(ii),1,'decimals'));
end
%
% Calculate incremental magnitude distribution
%
[idf, xx] = hist(eqevents(:,5),mags);
[~,ii] = max(idf);
%
% Estimate Magnitude of Completion
%
Mc_est = xx(max(find(idf == max(idf))))+McCorr;
% Mc = Mc_maxcurve(eqevents(:,5),MagBin,McCorr);
%
% Estimate B-value
%
[bvalue,~,L,Mc_bins,std_dev]=bval_maxlike(Mc,eqevents(eqevents(:,5)>=Mc,5),MagBin);
% [Mc,bvalue,~,L,Mc_bins,std_dev] = bvaltest(Mc_est,eqevents(:,5),MagBin);
%
% Maximum incremental step
%
maxincremcomp = mags(ii);
%
% Estimate magnitude of completeness??
%
estcomp = Mc;
%
% Plot Results
%
figure
hh4 = semilogy([Mc Mc],[10^0 10^6],'r--','LineWidth',1.5);
hold on
hh3 = semilogy(Mc_bins,L,'k--','LineWidth',1.5);
hh1 = semilogy(mags,cdf,'k+','linewidth',1.5);
hh2 = semilogy(xx,idf,'ro','linewidth',1.5);
%
% Figure Options
%
axis([minmag maxmag 10^0 10^6])
legend([hh1,hh2,hh3,hh4],['Cumulative'],['Incremental'],sprintf('B-value = %2.3f +- %2.3f',bvalue,std_dev),sprintf('Mc = %2.3f',Mc));
xlabel('Magnitude','fontsize',18)
ylabel('Number of Events','fontsize',18)
title(sprintf(['Magnitude Distributions for \n',catalog.name]),'fontsize',15)
set(gca,'linewidth',1.5)
set(gca,'fontsize',15)
set(gca,'box','on')
hold off
%
% Print out
%
disp(['Max Incremental: ',num2str(maxincremcomp)]);
disp(['Estimated Completeness (Maximum Likelihood): ',num2str(Mc)]);
disp([' ']);
%
% End of Function
%
end