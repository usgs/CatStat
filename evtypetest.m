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

types = unique(catalog.evtype);

if length(types) == 1
    disp(['Every event in the catalog falls within the same event class: ',types{1,1}])

else
typecount = [];
for ii = 1:length(types)
    name = types(ii,1);
    row = length(find(strcmp(types(ii,1),catalog.evtype)));
    fullrow = horzcat(name,row);
    typecount = [typecount;fullrow];
end

count = 1;
for ii = 1:length(typecount)
    catalog.evtype(strcmp(typecount(ii,1),catalog.evtype)) = {num2str(count)};
    count = count + 1;
end

%matrix = cell2mat(catalog.evtype);
%numeqtype = str2num(matrix(:,1));
numeqtype = str2double(catalog.evtype);
onecol = ones(length(numeqtype),1);

fullref = horzcat(catalog.data(:,1:5),numeqtype,onecol);

figure
subplot(2,1,1)
plot(fullref(:,1),fullref(:,6),'.')
if sizenum == 1
    datetick('x','yyyy','keepticks')
elseif sizenum == 2
    datetick('x','mm-yy')
else
    datetick('x','mm-dd-yy')
end
set(gca,'fontsize',15)
axis([fullref(1,1) fullref(length(fullref(:,1))) 0 (length(types)+1)]) 
ylabel('Event Type by Number','fontsize',18)
title('Event Types Through Time & Event Count','fontsize',18)

subplot(2,1,2)
hist(fullref(:,6),1:1:length(types))
set(gca,'fontsize',15)
%set(gca,'XTickLabel',[{types{1,:}};{types{2,:}};{types{3,:}};{types{4,:}}])
xlabel('Event Type by Number','fontsize',18)
ylabel('Number of Events','fontsize',18)
    

e = struct([]);
for count = 1:length(types) % Create structure divided by event type
        kk = find(fullref(:,6) == count);
        e(count).jj = fullref(kk,:);
        e(count).jj(:,8) = cumsum(e(count).jj(:,7));
end


figure
for count = 1:length(e)
    semilogy(e(count).jj(:,1),e(count).jj(:,8));
    hold on
end
if sizenum == 1
    datetick('x','yyyy')
elseif sizenum == 2
    datetick('x','mm-yy')
else
    datetick('x','mm-dd-yy')
end
set(gca,'fontsize',15)
xlabel('Event Type Through Time','fontsize',18)
ylabel('Cumulative Number of Events','fontsize',18)
legend(types,'Location','NorthWest')


count = 1;
for ii = 1:length(types)
    disp(['Event Type ',num2str(count),': ',types{count,1},' ',num2str(e(count).jj(length(e(count).jj(:,1)),8))]);
    count = count + 1;
end

end
