function [missingevents1,missingevents2,missingids1,missingids2] = missingevnts(cat1,cat2,tmax,delmax,setminlat,setmaxlat,setminlon,setmaxlon,setmaglim)
% This function find missing events from one catalog within the other -
% comparing both catalogs to each other.
% call missingevnts(cat1,cat2,tmax,delmax)
% Input: 
%  cat1,cat2 Two structures containing normalized catalog data
%         cat.name   name of catalog
%         cat.file   name of file contining the catalog
%         cat.data   real array of origin-time, lat, lon, depth, mag 
%         cat.id     character cell array of event IDs
%         cat.evtype character cell array of event types

%         tmax: max time window to search for matching events [seconds]
%         delmax: max distence window to search for matching events [km]    

% Output: None.

disp(' ')
disp('------- results from missingevnts function ------ ')
disp(' ')
disp(['Looking for events in ',cat1.name,' that are NOT in ',cat2.name])
disp(['Time window: ',num2str(tmax),' Distance window: ',num2str(delmax)])
tmax = tmax/24/60/60;
% Output of distance.m is in km, no need for degrees
%delmax = delmax/111.12;

disp(['Cat1 (',cat1.name,'): ',num2str(length(cat1.data(:,1)))])
disp(['Cat2 (',cat2.name,'): ',num2str(length(cat2.data(:,1)))])

% Trim catalogs to be same time period
startdate = max(cat2.data(1,1),cat1.data(1,1))-tmax;
enddate = min(cat2.data(length(cat2.data),1),cat1.data(length(cat1.data),1))+tmax;
disp(['Overlapping time period: ',datestr(startdate),' to ',datestr(enddate)])
%disp('Trimming catalogs to same time range...')
cat2.data(cat2.data(:,1)<startdate,:) = [];
cat1.data(cat1.data(:,1)<startdate,:) = [];
cat2.data(cat2.data(:,1)>enddate,:) = [];
cat1.data(cat1.data(:,1)>enddate,:) = [];

disp(['Cat1 post time trim: ',num2str(length(cat1.data(:,1)))])
disp(['Cat2 post time trim: ',num2str(length(cat2.data(:,1)))])

% Trim catalogs to be the same region
cat2.data(cat2.data(:,2)<(setminlat-1),:) = [];
cat1.data(cat1.data(:,2)<(setminlat-1),:) = [];
cat2.data(cat2.data(:,2)>(setmaxlat+1),:) = [];
cat1.data(cat1.data(:,2)>(setmaxlat+1),:) = [];
cat2.data(cat2.data(:,3)<(setminlon-1),:) = [];
cat1.data(cat1.data(:,3)<(setminlon-1),:) = [];
cat2.data(cat2.data(:,3)>(setmaxlon+1),:) = [];
cat1.data(cat1.data(:,3)>(setmaxlon+1),:) = [];

disp(['Cat1 post regional trim: ',num2str(length(cat1.data(:,1)))])
disp(['Cat2 post regional trim: ',num2str(length(cat2.data(:,1)))])

%Trim catalogs to a specific magnitude range/above set limit %% NEEDS EDITING
% cat1.data(cat1.data(:,5)<setmaglim,5) = NaN;
% cat2.data(cat2.data(:,5)<setmaglim,5) = NaN;
% cat1.data(isnan(cat1.data(:,5)),:) = [];
% cat2.data(isnan(cat2.data(:,5)),:) = [];
% 
% disp(['Cat1 post mag limit: ',num2str(length(cat1.data(:,1)))])
% disp(['Cat2 post mag limit: ',num2str(length(cat2.data(:,1)))])

  missingevents1 = [];
  missingids1 = [];
 
for ii = 1:length(cat1.data)
    %find time matches
    tdif = abs(cat1.data(ii,1)-cat2.data(:,1));
    timematch = cat2.data(tdif < tmax,:); 
    
    %find distance matches for events with matching time
    if(isempty(timematch))
        disp([cat1.id{ii,:},' ',datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:)))),' ',cat1.evtype{ii,:}])
        %missingids1 = [missingids1;cat1.id{ii,1}];
        missingevents1 = [missingevents1;cat1.data(ii,:)];
     else %look for matching distance
        [tdel] = distance_hvrsn(cat1.data(ii,2), cat1.data(ii,3),timematch(:,2),timematch(:,3));
        mindist = min(tdel);
        if(mindist > delmax)
          disp([cat1.id{ii,:},' ',datestr(cat1.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat1.data(ii,2:length(cat1.data(1,:)))),' match time not distance: ',num2str(mindist),' ',cat1.evtype{ii,:}])
          %missingevents1 = [missingevents1;cat1.data(ii,:)];
          %missingids1 = [missingids1;cat1.id{ii,:}];
        end
       %return
    end
    
    if(mod(ii,100000) == 0)
        disp(ii)
    end
end

if length(missingevents1) == 0;
    disp(['There are no missing events in ',cat1.name]);
    disp(['from the ',num2str(size(cat2.data,1)),' events in ',cat2.name]);
else
    disp(['There are ',num2str(size(missingevents1,1)),' ',cat1.name,' events missing ']);
    disp(['from the ',num2str(size(cat2.data,1)),' events in ',cat2.name]);
end

% % Plot missing events spatially on regional map
% maxlat = max(cat1.data(:,2)); 
% minlat = min(cat1.data(:,2));     
% maxlon = max(cat1.data(:,3));     
% minlon = min(cat1.data(:,3));
% latbuf = 0.1*(maxlat-minlat);
% lonbuf = 0.1*(maxlon-minlon);
% 
% mapminlon = max(minlon-lonbuf,-180);
% mapmaxlon = min(maxlon+lonbuf,180);
% mapminlat = max(minlat-latbuf,-90);
% mapmaxlat = min(maxlat+latbuf,90);
% 
% figure
% plot(cat1.data(:,3),cat1.data(:,2),'b.')
% daspect([1,1,1]);
% set(gca,'fontsize',15)
% axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
% hold on
% plot(missingevents(:,3),missingevents(:,2),'r.')
% daspect([1,1,1]);
% set(gca,'fontsize',15)
% axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
% hold on
% %plot(cat2.data(:,3),cat2.data(:,2),'g.')
% %daspect([1,1,1]);
% %set(gca,'fontsize',15)
% %axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
% %hold on
% 
% load ./Data/coastline.data
% coastline(coastline == 99999) = NaN;
% clat = coastline(:,2);
% clon = coastline(:,1);
% clon(abs(diff(clon))>180) = NaN;
% plot(clon,clat,'k','linewidth',1)
% xlabel('Longitude');
% ylabel('Latitude');
% title('USHIS Catalog - Events within 10s/100km');
% legend('In USHIS & ISCGEM','In USHIS, Missing from ISCGEM','Location','SouthWest');
% hold on
% 
% plot([minlon maxlon maxlon minlon minlon],[maxlat maxlat minlat minlat maxlat],'k');
% 
% disp(' ')
% disp(['Looking for events in ',cat2.name,' that are NOT in ',cat1.name])
% disp(['Time window: ',num2str(tmax*24*3600),' Distance window: ',num2str(delmax*111.12)])

missingevents2 = [];
missingids2 = [];

for ii = 1:length(cat2.data)
    %find for time matches
    tdif = abs(cat2.data(ii,1)-cat1.data(:,1));
    timematch = cat1.data(tdif < tmax,:);
    %find distance matches for events with matching time
    if(isempty(timematch))
        disp([datestr(cat2.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat2.data(ii,2:length(cat2.data(1,:))))])
        %disp([cat2.id{ii,:},' ',datestr(cat2.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat2.data(ii,2:length(cat2.data(1,:)))),' ',cat2.evtype{ii,:}])
        missingevents2 = [missingevents2;cat2.data(ii,:)];
        %missingids2 = [missingids2;cat2.id{ii,:}];
     else %look for matching distance
        [tdel] = distance_hvrsn(cat2.data(ii,2),cat2.data(ii,3),timematch(:,2),timematch(:,3));
        mindist = min(tdel);
        if(mindist > delmax)
          disp([datestr(cat2.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat2.data(ii,2:length(cat2.data(1,:)))),' match time not distance: ',num2str(mindist)])
          %disp([cat2.id{ii,:},' ',datestr(cat2.data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF'),' ',num2str(cat2.data(ii,2:length(cat2.data(1,:)))),' match time not distance: ',num2str(mindist*111.12),' ',cat2.evtype{ii,:}])
          %missingevents2 = [missingevents2;cat2.data(ii,:)];
          %missingids2 = [missingids2;cat2.id{ii,:}];
        end
       %return
    end
    
    if(mod(ii,100000) == 0)
        disp(ii)
    end
   
end

if length(missingevents2) == 0;
    disp(['There are no missing events in ',cat2.name]);
    disp(['from the ',num2str(size(cat1.data,1)),' events in ',cat1.name]);
else
    disp(['There are ',num2str(size(missingevents2,1)),' ',cat2.name,' events missing ']);
    disp(['from the ',num2str(size(cat1.data,1)),' events in ',cat1.name]);
end

% % Plot missing events spatially on regional map
% maxlat = max(cat2.data(:,2)); 
% minlat = min(cat2.data(:,2));     
% maxlon = max(cat2.data(:,3));     
% minlon = min(cat2.data(:,3));
% latbuf = 0.1*(maxlat-minlat);
% lonbuf = 0.1*(maxlon-minlon);
% 
% mapminlon = max(minlon-lonbuf,-180);
% mapmaxlon = min(maxlon+lonbuf,180);
% mapminlat = max(minlat-latbuf,-90);
% mapmaxlat = min(maxlat+latbuf,90);
% 
% figure
% plot(cat2.data(:,3),cat2.data(:,2),'b.')
% daspect([1,1,1]);
% set(gca,'fontsize',15)
% axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
% hold on
% plot(missingevents(:,3),missingevents(:,2),'r.')
% daspect([1,1,1]);
% set(gca,'fontsize',15)
% axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
% hold on
% %plot(cat1.data(:,3),cat1.data(:,2),'g.')
% %daspect([1,1,1]);
% %set(gca,'fontsize',15)
% %axis([mapminlon mapmaxlon mapminlat mapmaxlat]);
% %hold on
% 
% load ./Data/coastline.data
% coastline(coastline == 99999) = NaN;
% clat = coastline(:,2);
% clon = coastline(:,1);
% clon(abs(diff(clon))>180) = NaN;
% plot(clon,clat,'k','linewidth',1)
% xlabel('Longitude');
% ylabel('Latitude');
% title('ISCGEM Catalog - Events Within 10s/100km');
% legend('In ISCGEM & USHIS','In ISCGEM, Missing from USHIS','Location','SouthWest');
% hold on
% 
% plot([minlon maxlon maxlon minlon minlon],[maxlat maxlat minlat minlat maxlat],'k');
% 
