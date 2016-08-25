function [Mc_est] = catmagcomp(catalog,MagBin,McCorr)
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
eqevents(isnan(eqevents(:,5)),:) = []; % Remove NaN
%
% Round all mags to the nearest tenth
%
eqevents(:,5) = round(eqevents(:,5),1,'decimals');
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
minmag = min(eqevents(:,5));
if minmag > 0
    minmag = 0;
end
maxmag = max(eqevents(:,5));
mag_centers = minmag:MagBin:maxmag+MagBin;
cdf = zeros(length(mag_centers),1);
for ii = 1 : length(cdf);
    cdf(ii,1) = sum(eqevents(:,5) >= mag_centers(ii));
end
%
% Get incremental histogram
%
mag_edges = minmag-MagBin/2:MagBin:maxmag+MagBin/2;
[g_r,~] = histcounts(eqevents(:,5),mag_edges);
[idf,ii] = max(g_r);
%%
% Estimate Magnitude of Completion (Maximum Curvature method)
%
Mc_est = mag_centers(ii);
%
% Interate around estimated Mc to estimate best fit (Wiemer and Wyss, 2000)
%
[Mc_est,bvalue,avalue,L,Mc_bins,std_dev] = Wiemer_and_Wyss_2000(Mc_est,eqevents(:,5),MagBin);
%
% Maximum incremental step
%
maxincremcomp = mag_centers(ii);
%
% Plot Results
%
figure
hh4 = semilogy([Mc_est Mc_est],[10^0 10^6],'r--','LineWidth',1.5);
hold on
hh3 = semilogy(Mc_bins,L,'k--','LineWidth',1.5);
hh1 = semilogy(mag_centers,cdf,'k+','linewidth',1.5);
hh2 = semilogy(mag_centers(1:end-1),g_r,'ro','linewidth',1.5);
%
% Figure Options
%
axis([minmag maxmag 10^0 10^6])
legend([hh1,hh2,hh3,hh4],['Cumulative'],['Incremental'],sprintf('B-value = %2.3f +- %2.3f',bvalue,std_dev),sprintf('Mc = %2.3f',Mc_est));
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
disp(['Estimated Completeness (Maximum Likelihood): ',num2str(Mc_est)]);
disp([' ']);
%
% End of Function
%
end
