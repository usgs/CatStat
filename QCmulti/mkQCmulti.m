clear all; close all
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
    cat1.auth = char(initdat{1}{16}); 
    %
    % Get the information for the second catalog
    %
    cat2.file = [initpath,char(initdat{1}{6})];
    cat2.name = char(initdat{1}{8}); 
    cat2.auth = char(initdat{1}{16}); 
    %
    % Get comparison criteria
    %
    timewindow = str2double(initdat{1}{10}); % Time boundary
    distwindow = str2double(initdat{1}{12}); % Distance limit
    reg = char(initdat{1}{14}); % Region of interest
    maglim = str2double(initdat{1}{18}); % Magnitude lower limit
    magdelmax = str2double(initdat{1}{20}); % Magnitude residual limit
    depdelmax = str2double(initdat{1}{22}); % Depth residual limit
    %
    % Publishing options
    %
    pubopts.outputDir = char(initdat{1}{24}); % Output directory
    pubopts.format = 'html'; % Format option. See doc publish for more information
    pubopts.showCode = false; % Format option.  See doc publish for more information
    fclose(fid);
else
    % The files are not in the working directory, the
    % files will not be read.
    error('Input file not found.')
end
%
% Run remaining script and functions under publish function to create
% document
%
publish('QCmulti',pubopts)
%%
% 
%
% Create additional page to list missing events
%
EventThres = 1000;
if ~isempty(matching.cat1) && size(matching.cat1,1)<=EventThres
    publish('MatchingEvents',pubopts)
end
if ~isempty(missing.cat1) || ~isempty(missing.cat2)
    publish('MissingEvents',pubopts)
end
if ~isempty(mags.cat1) || ~isempty(dep.cat1) || ~isempty(both.cat1)
    publish('ProblemEvents',pubopts)
end

close all
%
% End of Script
%
