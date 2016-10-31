%% Generate Basic Catalog Report 
clear all; clf; close all; clc
% set init file to use
if exist('./initMkQCreport.dat','file')
    disp('using local initMkQCreport.dat file')
    initpath = ''; 
    initfile = ['./initMkQCreport.dat'];
    fid = fopen(initfile, 'rt');
    initdat = textscan(fid, '%s','delimiter', '\n');
    catalog.file = [initpath,char(initdat{1}{2})]; 
    catalog.name = char(initdat{1}{4}); 
    catalog.format = str2num(initdat{1}{6}); 
    catalog.timeoffset= str2num(initdat{1}{8}); 
    catalog.timezone =  char(initdat{1}{10});
    reg = char(initdat{1}{12});
    auth = char(initdat{1}{14});
    pubopts.outputDir = char(initdat{1}{16});
    pubopts.format = char(initdat{1}{18}); 
    pubopts.showCode = char(initdat{1}{20}); 
    if(strcmp(pubopts.showCode,'true'))
      pubopts.showCode = true;
    else
      pubopts.showCode = false;
    end
    fclose(fid);
    publish('QCreport',pubopts)
else 
  err('Input file not found.  Good-bye!');
end

