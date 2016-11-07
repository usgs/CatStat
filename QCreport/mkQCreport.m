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
    catalog.reg = char(initdat{1}{12});
    catalog.auth = char(initdat{1}{14});
    catalog.epoch = char(initdat{1}{16});
    pubopts.outputDir = char(initdat{1}{18});
    pubopts.format = 'html';
    pubopts.showCode = false;
    fclose(fid);
    publish('QCreport',pubopts)
else 
  err('Input file not found.  Good-bye!');
end

