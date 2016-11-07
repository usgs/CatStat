function [Mc_est] = catmagcomp(EQEvents,name,MagBin)
% This function determines the magnitude of completeness and plots
% FMD of EQEvents.  Initial estimate of Mc is determined using the
% maximum curvature method with a correction term determined using the
% methods of Wiemer and Wyss, 2000 in order to determine best fit to the
% data.  If data considered is too small, the algorithm will default to the
% initial estimate.
%
% Input:
%   EQEvents - data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type of earthquakes ONLY
%   Name - catalog name; typically saved as catalog.name
%   MagBin - binning width e.g. 0.1, 0.05, 0.1 is default
%
% Output: None
%
% Written by: Matthew R Perry
% Last Edit: 07 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get EQ only
%
ind = find(isnan(EQEvents.Mag));
if ~isempty(ind)
    EQEvents(ind,:) = []; % Remove NaN
end
%
% Round all mags to the nearest tenth
%
EQEvents.Mag = round(EQEvents.Mag,1,'decimals');
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
minmag = min(EQEvents.Mag);
if minmag > 0
    minmag = 0;
end
maxmag = max(EQEvents.Mag);
mag_centers = minmag:MagBin:maxmag+MagBin;
cdf = zeros(length(mag_centers),1);
for ii = 1 : length(cdf);
    cdf(ii,1) = sum(EQEvents.Mag >= mag_centers(ii));
end
%
% Get incremental histogram
%
mag_edges = minmag-MagBin/2:MagBin:maxmag+MagBin/2;
[g_r,~] = histcounts(EQEvents.Mag,mag_edges);
[idf,ii] = max(g_r);
%%
% Estimate Magnitude of Completion (Maximum Curvature method)
%
Mc_est = mag_centers(ii);
%
% Interate around estimated Mc to estimate best fit (Wiemer and Wyss, 2000)
% Algorithm will fail if sample size is too small.
try
    [Mc_est,bvalue,~,L,Mc_bins,std_dev] = Wiemer_and_Wyss_2000(Mc_est,EQEvents.Mag,MagBin);
catch
    Mc_est = Mc_est+0.3;
    Mc_bins = Mc_est:MagBin:maxmag;
    bvalue = log10(exp(1))/(mean(EQEvents.Mag(EQEvents.Mag>=Mc_est))-(Mc_est-MagBin/2));
    avalue = log10(length(EQEvents.Mag(EQEvents.Mag>=Mc_est))) + bvalue*Mc_est;
    log_L = avalue-bvalue.*Mc_bins;
    L = 10.*log_L;
    std_dev = bvalue/sqrt(length(EQEvents.Mag>=Mc_est));
end
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
title(sprintf(['Magnitude Distributions for \n',name]),'fontsize',15)
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
