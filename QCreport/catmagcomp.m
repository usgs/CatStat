function catmagcomp(yrmageqcsv,name)
% This function plots and compares the magnitude completeness. 
% Input:
%   yrmageqcsv - Magnitudes of earthquakes with year only in the time
%   column
%   name - catalog name
%
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MagBin = 0.1;
McCorr = 0.3;
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
minmag = floor(min(yrmageqcsv(:,5)));
if minmag > 0
    minmag = 0;
end
maxmag = ceil(max(yrmageqcsv(:,5)));
mags = minmag:0.1:maxmag;
cdf = zeros(length(mags),1);
%
% Calculate cumulative magnitude distribution
%
for ii = 1 : length(mags)
    cdf(ii) = sum(round(yrmageqcsv(:,5),1,'decimals')>=round(mags(ii),1,'decimals'));
end
%
% Calculate incremental magnitude distribution
%
[idf, xx] = hist(yrmageqcsv(:,5),mags);
[~,ii] = max(idf);
%
% Estimate Magnitude of Completion
%
Mc = Mc_maxcurve(yrmageqcsv(:,5),MagBin,McCorr);
%
% Estimate B-value
%
[bvalue,~,L,Mc_bins,std_dev]=bval_maxlike(Mc,yrmageqcsv(yrmageqcsv(:,5)>=Mc,5),MagBin);
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
hh1 = semilogy(mags,cdf,'k+','linewidth',1.5);
hold on
hh2 = semilogy(xx,idf,'ro','linewidth',1.5);
hh3 = semilogy(Mc_bins,L,'k--','LineWidth',1.5);
%
% Figure Options
%
axis([minmag maxmag 10^0 10^6])
legend([hh1,hh2,hh3],['Cumulative'],['Incremental'],sprintf('B-value = %2.3f +- %2.3f',bvalue,std_dev));
xlabel('Magnitude','fontsize',18)
ylabel('Number of Events','fontsize',18)
title(sprintf(['Magnitude Distributions for \n',name]),'fontsize',15)
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