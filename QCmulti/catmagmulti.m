function catmagmulti(cat1,cat2)
% This function plots and compares the magnitude completeness. 
% Input:
%   cat1 - Data structure for catalog 1
%   cat2 - Data structure for catalog 2
%
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% Catalog 1
%
%
% Determine Magnitude Range
%
minmag1 = floor(min(cat1.data(:,5)));
maxmag1 = ceil(max(cat1.data(:,5)));
mags1 = minmag1:0.1:maxmag1;
cdf1 = zeros(length(mags1),1);
%
% Calculate cumulative magnitude distribution
%
for ii = 1 : length(mags1)
    cdf1(ii) = sum(round(cat1.data(:,5),1,'decimals')>=round(mags1(ii),1,'decimals'));
end
%
% Calculate incremental magnitude distribution
%
[idf1, xx1] = hist(cat1.data(:,5),mags1);
[~,ii] = max(idf1);
%
% Maximum incremental step
%
maxincremcomp1 = mags1(ii);
%
% Estimate magnitude of completeness??
%
estcomp1 = mags1(ii) + 0.3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Catalog 2
%
minmag2 = floor(min(cat2.data(:,5)));
maxmag2 = ceil(max(cat2.data(:,5)));
mags2 = minmag2:0.1:maxmag2;
cdf2 = zeros(length(mags2),1);
%
% Calculate cumulative magnitude distribution
%
for ii = 1 : length(mags2)
    cdf2(ii) = sum(round(cat2.data(:,5),1,'decimals')>=round(mags2(ii),1,'decimals'));
end
%
% Calculate incremental magnitude distribution
%
[idf2, xx2] = hist(cat2.data(:,5),mags2);
[~,jj] = max(idf2);
%
% Maximum incremental step
%
maxincremcomp2 = mags2(jj);
%
% Estimate magnitude of completeness??
%
estcomp2 = mags2(jj) + 0.3;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot Results
%
figure
hh1 = semilogy(mags1,cdf1,'r+','MarkerSize',12,'LineWidth',1.5);
hold on
hh2 = semilogy(xx1,idf1,'ro','MarkerSize',12,'LineWidth',1.5);
hh3 = semilogy(mags2,cdf2,'b+','MarkerSize',8,'LineWidth',1.5);
hh4 = semilogy(xx2,idf2,'bo','MarkerSize',5,'LineWidth',1.5);
%
% Figure Options
%
axis([min(minmag1, minmag2) max(maxmag1, maxmag2) 10^0 10^6])
legend([hh1,hh2,hh3,hh4],[cat1.name],'Incremental',[cat2.name],'Incremental')
xlabel('Magnitude','fontsize',18)
ylabel('Number of Events','fontsize',18)
title(sprintf(['Magnitude Distributions for \n',cat1.name,' and ',cat2.name]),'fontsize',15)
set(gca,'linewidth',1.5)
set(gca,'fontsize',14)
set(gca,'box','on')
hold off
drawnow
%
% Print out
%
disp(['Max Incremental for ',cat1.name,': ',num2str(maxincremcomp1)]);
disp(['Estimated Completeness for ',cat1.name,': ',num2str(estcomp1)]);
disp([' ']);
disp(['Max Incremental for ',cat2.name,': ',num2str(maxincremcomp2)]);
disp(['Estimated Completeness for ',cat2.name,': ',num2str(estcomp2)]);
disp([' ']);
%
% End of Function
%
end