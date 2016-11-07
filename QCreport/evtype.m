function evtypetest(catalog,sizenum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function plots event types and frequencies over the entire catalog. 
% Input: Necessary components described
%       catalog.data -  data table containing ID, OriginTime, Latitude,
%                      Longitude, Depth, Mag, and Type
%       sizenum - plot formatting option from basiccatsum
%
% Output: None
%
% Written by: Matthew R Perry
% Last Edit: 07 November 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get unique event types
% 
types = unique(catalog.data.Type);
% Set blank arrays and cells
labels = cell(1,size(types,1));
numeqtype = zeros(size(catalog.data,1),1);
if size(types,1) == 1
    disp(['Every event in the catalog falls within the same event class: ',types{1,1}])
else
    %
    % Get 'time-series' of Event Types
    %
    for ii = 1 : length(types)
        StrucName{ii} = strrep(types{ii},' ','_'); % Can't have spaces in structure names
        numeqtype(strcmp(types{ii},catalog.data.Type)) = ii;
        EvTypeCounts(ii,:) = [ii, sum(numeqtype == ii)];
        % Get cumulative sum of event types through time
        ETypes.(StrucName{ii})(:,[1 2]) = [catalog.data.OriginTime,cumsum(numeqtype==ii)];
        % Save label for plotting
        labels{1,ii} = types{ii};
    end
    %
    % Figure
    %
    % Subplot 1; Event type 'time series'
    figure;clf
    subplot(2,1,1)
    plot(catalog.data.OriginTime,numeqtype,'k.')
    set(gca,'YTick',1:1:length(types))
    set(gca,'YTickLabel',labels)
    if sizenum == 1
        datetick('x','yyyy','keepticks')
    elseif sizenum == 2
        datetick('x','mm-yy')
    else
        datetick('x','mm-dd-yy')
    end
    set(gca,'fontsize',13)
    axis([min(catalog.data.OriginTime) max(catalog.data.OriginTime) 0 (length(types)+1)]) 
    title('Event Types Through Time & Event Count','fontsize',18)
    %
    % Subplot 2; Event type bar grapg
    %
    subplot(2,1,2)
    hist(numeqtype,1:1:length(types))
    set(gca,'fontsize',13)
    set(gca,'XTick',1:1:length(types))
    set(gca,'XTickLabel',labels)
    ylabel('Number of Events','fontsize',18)
    %
    % Figure; Cumulative number of events by event type through time
    %
    figure;clf
    hold on
    for ii = 1 : length(types)
        plot(ETypes.(StrucName{ii})(:,1),ETypes.(StrucName{ii})(:,2))
    end
    set(gca,'YScale','log')
    if sizenum == 1
        datetick('x','yyyy','keepticks')
    elseif sizenum == 2
        datetick('x','mm-yy')
    else
        datetick('x','mm-dd-yy')
    end
    xlabel('Event Type Through Time','fontsize',18)
    ylabel('Cumulative Number of Events','fontsize',18)
    legend(types,'Location','NorthWest')
    set(gca,'XTickLabelRotation',45)
    drawnow
    %
    % Print out
    %
    for ii = 1:length(types)
        disp(['Event Type ',num2str(ii),': ',types{ii},' ',num2str(EvTypeCounts(ii,2))]);
    end

end
%
% End of Function
%
end
