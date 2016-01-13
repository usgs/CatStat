function [dist_km] = distance(lat1, lon1, lat2, lon2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the distance between two points on the globe using the
% haversine formula.
%
% Input:
% lat1 - decimal latitude of the first point
% lon1 - decimal longitude of the first point
% lat2 - decimal latitude of the second point
% lon2 - decimal longitude of the second point
%
% Output
% dist_degree - distance in degrees
% dist_km - distance in kilometers
% 
% Last Edited: 13 January 2016 by Matthew R. Perry
% Comments: Changed to one output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R = 6371000.;    % Earth's radius (m)
d2r = pi/180;    % deg = rad*180/pi
% Convert degree latitude and longitude to radians
si1 = d2r*(lat1);
si2 = d2r*(lat2);
% Convert latitude and longitude differences to radians 
si_del = d2r*(lat2 - lat1);
lam_del = d2r*(lon2 - lon1);
% Haversine forumlation for distance
a = (sin(si_del/2).^2) + (cos(si1).*cos(si2).*(sin(lam_del/2)).^2);
c = 2 * atan2(sqrt(a), sqrt(1-a));
%Convert distance radians back to degrees
dist_km = (R*c)/1000;
%dist_degree = c * 180/pi;
end
% End of function

