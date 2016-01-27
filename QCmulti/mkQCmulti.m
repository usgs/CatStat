clc; clear all; close all
% This is the initial script for comparing two catalogs, which relies on
% the initMkQCmulti.dat file to locate the catalog .csv files, and provide
% importance parameters for the comparison.  The only file that needs to be
% located within the working directory is the initMkQCmulti.dat file.  All
% other files (e.g. catalog .csv files) may be defined with their path in
% the input file
%
% If you wish to run this without the input file in the current working
% directory, please change the initfile variable below to reflect the
% correct path.
%
initfile = './initMkQCmulti.dat';
%
% In order for this and the follow-on scripts to work, they must be in your
% MATLAB path.
%
% Begin script
%
if exist(initfile,'file')
    disp('initMkQCmulti.dat located.')
    disp('Loading catalog information and comparison criteria.')
    disp('Creating document...')
    initpath = '';
    %
    % Get the information for the first catalog
    %
    fid = fopen(initfile, 'rt');
    initdat = textscan(fid, '%s','delimiter', '\n');
    cat1.file = [initpath,char(initdat{1}{2})];
    cat1.name = char(initdat{1}{4}); 
    cat1.format = str2double(initdat{1}{6}); 
    %
    % Get the information for the second catalog
    %
    cat2.file = [initpath,char(initdat{1}{8})];
    cat2.name = char(initdat{1}{10}); 
    cat2.format = str2double(initdat{1}{12}); 
    %
    % Get comparison criteria
    %
    timewindow = str2double(initdat{1}{14}); % Time boundary
    distwindow = str2double(initdat{1}{16}); % Distance limit
    reg = char(initdat{1}{18}); % Region of interest
    maglim = str2double(initdat{1}{20}); % Magnitude lower limit
    magdelmax = str2double(initdat{1}{22}); % Magnitude residual limit
    depdelmax = str2double(initdat{1}{24}); % Depth residual limit
    %
    % Publishing options
    %
    pubopts.outputDir = char(initdat{1}{26}); % Output directory
    pubopts.format = char(initdat{1}{28}); % Format option. See doc publish for more information
    pubopts.showCode = char(initdat{1}{30}); % Format option.  See doc publish for more information
    if(strcmp(pubopts.showCode,'true'))
        pubopts.showCode = true;
    else
        pubopts.showCode = false;
    end
    %
    % Will determine if missing events are printed.
    % 
    EL = char(initdat{1}{32});
    fclose(fid);
else
    % The files are not in the working directory, the
    % files will not be read.
    disp('The "init" files missing from working directory.')
    disp('Please run from directory containing these "init" files,')
    disp('or change the paths in loadmulticat.m.')
end
%
% Run remaining script and functions under publish function to create
% document
%
publish('QCmulti',pubopts)
% 
% 
%
% Create additional page to list missing events
%
if strcmpi(EL,'yes')
	if ~isempty(matching.data)
		publish('MatchingEvents',pubopts)
	end
	if ~isempty(missing.events1) || ~isempty(missing.events2)
		publish('MissingEvents',pubopts)
    end
    if ~isempty(mags.events1) || ~isempty(dep.events1) || ~isempty(both.events1)
		publish('ProblemEvents',pubopts)
	end
end
close all

% End of Script
%

