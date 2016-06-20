function [Mc] = Mc_maxcurve(Mags,MagBin,McCorr)
MaxMag = max(Mags);
MinMag = min(Mags);
if MinMag > 0;
    MinMag = 0;
else
    MinMag = round(MinMag,1,'decimals');
end
maxMag = round(MaxMag,1,'decimals');
bins = MinMag:MagBin:MaxMag;
[MagHist, MagBins] = hist(Mags,bins);
Mc = MagBins(max(find(MagHist == max(MagHist))));
if isempty(Mc)
    Mc = nan;
end
Mc = Mc + McCorr;
Mc_Mags = Mags(Mags>=Mc);