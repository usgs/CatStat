function [] = Mc_lqs(Mags,MagBin)
MaxMag = max(Mags);
MinMag = min(Mags);
ii = 0;
sx=0;sy=0;sxy=0;sxx=0;
for count=MinMag:MagBin:MagMax
    ii = ii + 1;
    x(ii) = count;
    ylin=length(Mags(Mags>= count));
    if ylin>0
        y(ii) = log10(ylin);
    else
        y(i) = 0;
    end
    sx=sx+x(i);
    sy=sy+y(i);
    sxy=sxy+x(i)*y(i);
    sxx=sxx+x(i)^2;
end
nbins = ii;
ii = 0;
num=0;denom=0;
for count=MinMag:MagBin:MaxMag
    ii = ii + 1;
    num=num+(x(ii)-sx/nbins)*(y(ii)-sy/nbins);
    denom=denom+(x(ii)-sx/nbins)^2.;
end
b = -num/denom;
a=sy/nbins+sx/nbins*b;
