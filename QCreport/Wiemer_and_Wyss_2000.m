function [Mc,bvalue,avalue,L,Mag_bins,std_dev] = Wiemer_and_Wyss_2000(Mc,Mags,bin_size)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function based off the methods in Wiemer and Wyss, 2000 that searches for
% the best fit for a given Mc.  Will take Mc estimated from maximum
% curvature method and search within +-1.5 Mag units for best fit.  "Best
% fit" is taken to be either the Mc associate with the smallest residual or
% the first time the goodness-of-fit becomes greater than 90%.
%
% Input: Necessary components described
%       Mc - estimated Magnitude of Completeness
%       Mags - Magnitudes from EQEvents
%       bin_size- Magnitude bin size; default if 0.1.
%
% Output: 
%       Mc - refined Mc estimate
%       bvalue - B-value associated with Mc
%       avalue - A-value associated with Mc
%       L      - Synthetic CDF determined using B- and A-values.
%       Mag-bins - Magnitude bins used in detemining L
%       std_dev - Standard deviation of B-value.
%
% Written by: Matthew R Perry
% Last Edit: 07 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Make sure Mags are rounded to nearest tenth, no NaNs also
    Mags(isnan(Mags)) = [];
    Mags = round(Mags,1,'decimal');
    Mc_vec = Mc-1.5:bin_size:Mc+1.5;
    max_mag = max(Mags);
    Corr = bin_size/2;
    for ii = 1 : length(Mc_vec)
        %clear variables
        clear M Mag_bins_edges Mag_bins_centers B S L log_L
        %
        % Magnitude vector >= Iterative Mc
        %
        M = Mags(Mags >= Mc_vec(ii));
        Mag_bins_edges = Mc_vec(ii)-bin_size/2:bin_size:max_mag+bin_size/2;
        Mag_bins_centers = Mc_vec(ii):bin_size:max_mag;
        %
        % Get length of Magnitude vector
        %
        cdf = zeros(length(Mag_bins_centers),1);
        for jj = 1 : length(cdf)
            cdf(jj) = sum(M>=Mag_bins_centers(jj));
        end
        %
        % Calculate bvalue and std based on _______ CITE ME PLEASE!
        %
        bvalue(ii) = log10(exp(1))/(mean(M)-(Mc_vec(ii)-Corr));
        std_dev(ii) = bvalue(ii)/sqrt(cdf(1));
        %
        % Calculate avalue
        %
        avalue(ii) = log10(length(M)) + bvalue(ii)*Mc_vec(ii);
        log_L = avalue(ii) - bvalue(ii).*Mag_bins_centers;
        L = 10.^log_L;
        %
        % Get Number of Events per Bin
        %
        [B,~] = histcounts(M,Mag_bins_edges);
        S = abs(diff(L));
        R(ii) = (sum(abs(B(1:end-1) - S))/length(M))*100;
        tt(ii) = length(M);
    end
    % Find first value to fall under 10% (90% fit)
    ind = find(R <= 10);
    if ~isempty(ind)
        ii = ind(1);
    else
        [~,ii] = min(R);
    end
    Mc = Mc_vec(ii);
    bvalue = bvalue(ii);
    avalue = avalue(ii);
    std_dev = std_dev(ii);
    Mag_bins = 0:bin_size:max_mag;
    L = 10.^(avalue-bvalue.*Mag_bins);
