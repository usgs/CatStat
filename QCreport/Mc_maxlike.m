function [Mc] = Mc_maxlike(Mags,MagBin,McCorr)
MaxMag = max(Mags);
MinMag = min(Mags);
if MinMag > 0;
    MinMag = 0;
end
bins = MinMag:MagBin:MaxMag;
[MagHist, MagBins] = hist(Mags,bins);
Mc = MagBins(max(find(MagHist == max(MagHist))));
if isempty(Mc)
    Mc = nan;
end
Mc = Mc + McCorr;