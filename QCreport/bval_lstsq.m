function [bvalue,avalue,std_dev,std_err,L] = bval_lstsq(Mags,MagBin,Mc_bins)
MaxMag = max(Mags);
MinMag = min(Mags);
mean_mag = mean(Mags);
neq = length(Mags);
ii = 0;
sx=0;sy=0;sxy=0;sxx=0;
for count=MinMag:MagBin:MaxMag
    ii = ii + 1;
    x(ii) = count;
    ylin=length(Mags(Mags>= count));
    if ylin>0
        y(ii) = log10(ylin);
    else
        y(ii) = 0;
    end
    sx=sx+x(ii);
    sy=sy+y(ii);
    sxy=sxy+x(ii)*y(ii);
    sxx=sxx+x(ii)^2;
end
nbins = ii;
ii = 0;
num=0;denom=0;
for count=MinMag:MagBin:MaxMag
    ii = ii + 1;
    num=num+(x(ii)-sx/nbins)*(y(ii)-sy/nbins);
    denom=denom+(x(ii)-sx/nbins)^2.;
end
bvalue = -num/denom;
avalue = sy/nbins+sx/nbins*bvalue;
L = 10.^(avalue-bvalue.*Mc_bins);
std_dev = (sum((Mags-mean_mag).^2))/(neq*(neq-1));
std_err = 2.30 * sqrt(std_dev) * bvalue^2;
