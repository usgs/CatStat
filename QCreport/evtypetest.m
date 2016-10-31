function evtypetest(catalog,sizenum)
% This function plots and compares event types and their frequencies over the span of the catalog. 
% Input: a structure containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types 
% TEST
% Output: None

types = unique(catalog.data.Type);

if size(types,1) == 1
    disp(['Every event in the catalog falls within the same event class: ',types{1,1}])

else
typecount = [];
for ii = 1:length(types)
    name = types(ii,1);
    row = length(find(strcmp(types(ii,1),catalog.data.Type)));
    fullrow = horzcat(name,row);
    typecount = [typecount;fullrow];
end

count = 1;
for ii = 1:length(typecount)
    catalog.data.Type(strcmp(typecount(ii,1),catalog.data.Type)) = {num2str(count)};
    count = count + 1;
end
numeqtype = str2double(catalog.data.Type);
onecol = ones(length(numeqtype),1);

% fullref = horzcat(catalog.data(:,1:5),numeqtype,onecol);

figure
subplot(2,1,1)
plot(catalog.data.OriginTime,numeqtype,'.')
if sizenum == 1
    datetick('x','yyyy','keepticks')
elseif sizenum == 2
    datetick('x','mm-yy')
else
    datetick('x','mm-dd-yy')
end
set(gca,'fontsize',15)
axis([min(catalog.data.OriginTime) max(catalog.data.OriginTime) 0 (length(types)+1)]) 
ylabel('Event Type by Number','fontsize',18)
title('Event Types Through Time & Event Count','fontsize',18)

subplot(2,1,2)
hist(numeqtype,1:1:length(types))
set(gca,'fontsize',15)
% set(gca,'XTickLabel',[{types{1,:}};{types{2,:}};{types{3,:}};{types{4,:}}])
xlabel('Event Type by Number','fontsize',18)
ylabel('Number of Events','fontsize',18)
    
%% Need to fix below here
% e1 = struct([]);
% for count = 1:length(types) % Create structure divided by event type
%         kk = find(numeqtype == count);
%         e1(count).jj = onecol;
%         e1(count).jj(:,2) = cumsum(e1(count).jj(:,1));
% end
% 
% 
% figure
% for count = 1:length(e1)
%     semilogy(catalog.data.OriginTime,e1(count).jj(:,2));
%     hold on
% end
% if sizenum == 1
%     datetick('x','yyyy')
% elseif sizenum == 2
%     datetick('x','mm-yy')
% else
%     datetick('x','mm-dd-yy')
% end
% set(gca,'fontsize',15)
% xlabel('Event Type Through Time','fontsize',18)
% ylabel('Cumulative Number of Events','fontsize',18)
% legend(types,'Location','NorthWest')
% set(gca,'XTickLabelRotation',45)
% count = 1;
% for ii = 1:length(types)
%     disp(['Event Type ',num2str(count),': ',types{count,1},' ',num2str(e1(count).jj(length(e1(count).jj(:,1)),2))]);
%     count = count + 1;
% end

end
