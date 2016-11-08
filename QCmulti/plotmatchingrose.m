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
B = forwardbearing(matching.cat1.Latitude,matching.cat1.Longitude,...
    matching.cat2.Latitude,matching.cat2.Longitude);
%
% Initialize Figure
%
B=B(B~=0);
if ~isempty(B)
    figure
    rose(B)
    set(gca,'View',[-90 90],'YDir','reverse')
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
function bearing=forwardbearing(lat1,lon1,lat2,lon2)
    %
    % Calculate the two parts
    %
    A = sind(lon2-lon1).*cosd(lat2);
    b = cosd(lat1).*sind(lat2)-sind(lat1).*cosd(lat2).*cosd(lon2-lon1);
    %
    % Get the bearing
    %
    bearing = atan2d(A,b);
    bearing = mod(bearing+360,360);
end
%
%End of function
%
end