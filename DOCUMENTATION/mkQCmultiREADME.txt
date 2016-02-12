As long as the path to CatStat and QCMulti are in your startup.m file, you can run mkQCreport or mkQCmulti from any directory that has the input file in it.  You do not need to run mkQCmulti from the MATLAB directory.  
    For example, say I want to run a catalog comparison QC report on the Southern California Catalog and ComCat. The Southern Californation catalog data is located in ~/Documents/CATALOGS/CI/CI.csv while the ComCat data is located in ~/Documents/CATALOGS/ComCom/ComCat.csv.  I have another directory, ~/Documents/QCmulti/CI_ComCat, under which I would like to file the report.  In this directory, I place the initMkQCmulti.dat file.  The input file should read (something like this):

% First catalog data file name
~/Documents/CATALOGS/CI/CI.csv
% Human readable catalog description
CI Catalog
% Catalog Format 1 = ComCat CSV; 2 = libcomcat CSV format
1
% Second catalog Data file name
~/Documents/CATALOGS/ComCat/ComCat.csv
% Human readable catalog description
ComCat
% Catalog Format 1 = ComCat CSV; 2 = libcomcat CSV format
2
% Time Window
16
% Distance Range
100
% Region
CI
% Set Mag Limit
0
% Set Mag Difference Max
0.5
% Set Depth difference tolerance
1  
% Diretory to put report in
Report
% File format for report
html
% show code in report (true/false)
false
% Display event list
yes 

Now, in MATLAB if you change directories to the directory where the appropriate initMkQCmulti.dat file is (i.e. ~/Documents/QCmulti/CI_ComCat) and type mkQCmulti, it should produce a report in the specified format in a folder under the current working directory. If no input file is in the current directory, the report will not compile, and you will receive an error. 

email any questions or comments to: mrperry@usgs.gov

