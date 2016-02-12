As long as the path to CatStat and QCMulti are in your startup.m file, you can run mkQCreport or mkQCmulti from any directory that has the input file in it.  You do not need to run mkQCreport from the MATLAB directory.  
    For example, say I want to run a QC report on the Southern California Catalog.  My catalog data is located in ~/Documents/CATALOGS/CI/CI.csv.  I have another directory, ~/Documents/QCReports/CI, under which I would like to file the report.  In the directory, I place the initMkQCreport.dat file.  The initMkQCreport.dat file should read (something like this):

% Catalog Data file name
~/Documents/CATALOGS/CI/CI.csv
% Human readable catalog description
California Institute of Technology
% Catalog Format 1 = ComCat CSV; 2 = libcomcat CSV format
2
% UTC offset [hours]
-8
% Time Zone
Pacific Standard Time UTC-8
% Diretory to put report in
Report
% File format for report
html
% show code in report (true/false)
false

Now, in MATLAB if you change directories to the directory where the appropriate initMkQCreport.dat file is (i.e. ~/Documents/QCReports/CI) and type mkQCreport, it should produce a report in the specified format in a folder under the current working directory.  If for some reason you do not see "Using local initMkQCreport.dat file" in your MATLAB command window, then the intiMkQCreport.dat is not in your current directory.  Because of the way mkQCreport is currently set-up, the program will run but will produce a generic report using the default initMkQCreport.dat.

Email any questions or comments to: mrperry@usgs.gov
