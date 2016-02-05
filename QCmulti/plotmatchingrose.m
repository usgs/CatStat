function plotmatchingrose(matching,cat1name,cat2name)
%
% Function to plot the azimuthal deviation in earthquake locations
%
% Input: matching - matching events data structure
%        cat1name - name for catalog 1
%        cat2name - name for catalog 2
%
% Output: None
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get vector of azimuths
%
B = forwardbearing(matching.data(:,2),matching.data(:,3),matching.data2(:,2),matching.data2(:,3));
%
% Initialize Figure
%
figure
rose(B)
%
% Formatting
%
title('Azimuth')
set(gca,'FontSize',14)
title(sprintf(['Azimuth Histogram: \n',cat1name,' - ',cat2name]))
set(gca,'FontSize',14)
hold off
drawnow
%
%End of function
%
end