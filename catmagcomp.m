function catmagcomp(yrmageqcsv)
% This function plots and compares the magnitude completeness. 
% Input:
%   yrmageqcsv - Magnitudes of earthquakes with year only in the time
%   column
%
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Display
%
disp(['Magnitude distribution of earthquake events only. All other event types ignored.']);
disp([' ']);
disp(['Cumulative and incremental distributions provide an indication of ']);
disp(['catalog completeness. The max of the incremental distribution is ']);
disp(['generally 0.2 or 0.3 magnitude units smaller than the catalog ']);
disp(['completness. This completeness estimation is not valid for catalogs ']);
disp(['whose completeness varies in time.']);
disp([' ']);
%
% Determine Magnitude Range
%
minmag = floor(min(yrmageqcsv(:,5)));
maxmag = ceil(max(yrmageqcsv(:,5)));
mags = minmag:0.1:maxmag;
cdf = zeros(length(mags));
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
% Maximum incremental step
%
maxincremcomp = mags(ii);
%
% Estimate magnitude of completeness??
%
estcomp = mags(ii) + 0.3;
%
% Plot Results
%
figure
hh1 = semilogy(mags,cdf,'k+','linewidth',1.5);
hold on
hh2 = semilogy(xx,idf,'ro','linewidth',1.5);
%
% Figure Options
%
axis([minmag maxmag 10^0 10^6])
legend('Cumulative','Incremental')
xlabel('Magnitude','fontsize',18)
ylabel('Number of Events','fontsize',18)
title('Magnitude Distributions','fontsize',18)
set(gca,'linewidth',1.5)
set(gca,'fontsize',15)
set(gca,'box','on')
hold off
%
% Print out
%
disp(['Max Incremental: ',num2str(maxincremcomp)]);
disp(['Estimated Completeness: ',num2str(estcomp)]);
disp([' ']);
%
% End of Function
%
end