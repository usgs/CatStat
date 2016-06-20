function [bvalue,avalue,L,Mag_bins]=bval(Mc,Mags,bin_size)
max_mag = max(Mags);
Mag_bins = Mc:bin_size:max_mag;
%
% Calculate b-value
%
bvalue = log10(exp(1))/(mean(Mags)-(Mc-(bin_size/2)));
%
% 
%
neq = length(Mags);
avalue = log10(neq);% + bvalue*Mc;
%std_dev = (sum((Mags-mean_mag).^2))/(neq*(neq-1));
%std_err = 2.30 * sqrt(std_dev) * bvalue^2;
L = 10.^(avalue-bvalue.*Mag_bins);