%
% This function plots the world map, along with U.S. State borders
%
% WHERE IS DATA FROM!
function [] = plotworld
load('Countries.mat');
L = length(places);
hold on
for ii = 1 : L
    plot(lon{ii,1}(:), lat{ii,1}(:),'k')
end
end
    