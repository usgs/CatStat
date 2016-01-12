%% Generate Basic Catalog Report 

clear

% set init file to use
if exist('./initMkQCreport.dat','file')
  disp('using local initMkQCreport.dat file')
  initpath = ''; 
  initfile = ['./initMkQCreport.dat']
else 
  disp('using default initMkQCreport.dat file')
  [initpath,tmpname,tmpext] = fileparts(which('mkQCreport'));
  initpath = [initpath,'/'];
  initfile = [initpath,'/initMkQCreport.dat']
end

initfile;

fid = fopen(initfile, 'rt');
initdat = textscan(fid, '%s','delimiter', '\n');

catalog.file = [initpath,char(initdat{1}{2})]; 

catalog.name = char(initdat{1}{4}); 
catalog.format = str2num(initdat{1}{6}); 
catalog.timeoffset= str2num(initdat{1}{8}); 
catalog.timezone =  char(initdat{1}{10}); 
pubopts.outputDir = char(initdat{1}{12});
pubopts.format = char(initdat{1}{14}); 
pubopts.showCode = char(initdat{1}{16}); 
if(strcmp(pubopts.showCode,'true'))
  pubopts.showCode = true;
else
 pubopts.showCode = false;
end

fclose(fid)

catalog
pubopts

%QCreport
publish('QCreport',pubopts)
