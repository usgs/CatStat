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
% Get vector of azimuths (ignoring exact matches)
%
disp('Exact matches ignored for rose histogram plot')
B = forwardbearing(matching.data(:,2),matching.data(:,3),matching.data2(:,2),matching.data2(:,3));
%
% Initialize Figure
%
B=B(B~=0);
if ~isempty(B)
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
else
    disp('No plot due to exact location matches.')
end
%
%End of function
%
end