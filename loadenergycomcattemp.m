function [cat] = loadenergycomcattemp(pathname1,catname1)

cat.file = pathname1;
cat.name = catname1;
fid = fopen(cat.file, 'rt');
S = textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f');
fclose(fid);

add19 = S{1,1}(1:1568,1);
matrix = zeros(length(add19),1);
nineteen = matrix+19;
years1 = [nineteen,add19];
years1 = num2cell(years1);
for i = 1:size(years1,1)
    years1{i,1} = [num2str(years1{i,1}),num2str(years1{i,2})];
end
years1(:,2) = [];
years1 = cell2mat(years1);
years1 = str2num(years1);

add200 = S{1,1}(1569:3039,1);
matrix = zeros(length(add200),1);
twohundred = matrix+200;
years2 = [twohundred,add200];
years2 = num2cell(years2);
for i = 1:size(years2,1)
    years2{i,1} = [num2str(years2{i,1}),num2str(years2{i,2})];
end
years2(:,2) = [];
years2 = cell2mat(years2);
years2 = str2num(years2);

add20 = S{1,1}(3040:3401,1);
matrix = zeros(length(add20),1);
twenty = matrix+20;
years3 = [twenty,add20];
years3 = num2cell(years3);
for i = 1:size(years3,1)
    years3{i,1} = [num2str(years3{i,1}),num2str(years3{i,2})];
end
years3(:,2) = [];
years3 = cell2mat(years3);
years3 = str2num(years3);

allyears = [years1;years2;years3];
allmonths = S{2};
alldays = S{3};

yrmthday = datenum(allyears,allmonths,alldays);

time = S{4};
hours = floor(time/10000);
min = floor(((time/10000)-floor(time/10000))*100);
sec = ((((time/10000)-floor(time/10000))*100)-floor(((time/10000)-floor(time/10000))*100))*100;

fulltime = datenum(allyears,allmonths,alldays,hours,min,sec);

mag = (2/3)*(log10(S{8})-4.4);

evtype = zeros(length(mag),1);
evtype = num2cell(evtype);
for ii = 1:length(evtype)
    evtype{ii,1} = 'earthquake';
end

[cat.data,ii] = sortrows(horzcat(fulltime,S{5:7},mag),1);
cat.id = evtype(ii);
cat.evtype = evtype(ii);

cat.data(cat.data(:,4)==999,4) = NaN;
cat.data(cat.data(:,4)==899,4) = NaN;



