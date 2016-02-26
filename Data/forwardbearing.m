function bearing=forwardbearing(lat1,lon1,lat2,lon2)

%
% Calculate the two parts
%
A = sind(lon2-lon1).*cosd(lat2);
B = cosd(lat1).*sind(lat2)-sind(lat1).*cosd(lat2).*cosd(lon2-lon1);
%
% Get the bearing
%
bearing = atan2d(A,B);
bearing = mod(bearing+360,360);