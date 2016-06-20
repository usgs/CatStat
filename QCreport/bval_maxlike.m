function [bvalue,avalue,L,Mag_bins,std_dev]=bval_maxlike(Mc,Mags,bin_size)
%
% Make sure only those events with magnitudes above Mc are used
%
Mags = Mags(Mags >= Mc,:);
neq = length(Mags);
%
% Get maximum magnitude, and construct vector
%
mean_mag = mean(Mags);
max_mag = max(Mags);
Mag_bins = Mc:bin_size:max_mag;
%
% Get new CDF for A-value calculation
%
cdf = zeros(length(Mag_bins),1);
for ii = 1 : length(cdf)
    cdf(ii) = sum(round(Mags,1,'decimals')>=round(Mag_bins(ii),1,'decimals'));
end
%
% Calculate b-value and std using equations 3.1 and 3.4 Marzocchi and Sandri (2003)
%
bvalue = log10(exp(1))/(mean_mag-(Mc-(bin_size/2)));
std_dev = bvalue/sqrt(neq);
avalue = log10(cdf(1)) + bvalue*Mc;
L = 10.^(avalue-bvalue.*Mag_bins);