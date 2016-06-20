%
% This function plots the world map, along with U.S. State borders
%
% WHERE IS DATA FROM!
function [] = plotworld
load('Countries.mat');
L = length(places);
hold on
for ii = 1 : L
    Lon = lon{ii,1};
    Lat = lat{ii,1};
    plot(Lon, Lat,'k')
end
end
    