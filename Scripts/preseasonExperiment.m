
addpath('../Ryan/')

START_YEAR = 1971;
END_YEAR = 2010;
SST_MONTHS = 6:10;

% Set up dataLims to search East Atlantic region during the preseason
dataLims = struct('west', -45, 'east', -10, 'north', 45, 'south', 5, ... 
    'minWidth', 8, 'maxWidth', 15, 'minHeight', 8, 'maxHeight', 15, 'step', 1, ... 
    'months', SST_MONTHS, 'startYear', START_YEAR, 'endYear', END_YEAR);

% Load the ERV3SST data set
load /project/expeditions/haasken/data/ERSST/ersstv3.mat
% Get May-July seasonal data
seasonal = monthlyToSeasonal(erv3sst, erv3Dates, SST_MONTHS, START_YEAR, END_YEAR);

% Get box data for the region
allBoxSST = getAllBoxData(erv3sst, erv3Dates, erv3GridInfo, dataLims);

% Load the storm data and get counts
load /project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat
storms = condensedHurDat(:, [1 2 6 7]);
atlCounts = countStorms(storms, START_YEAR, END_YEAR, 6:10, [5 35], [-100 -10]);
eatlCounts = countStorms(storms, START_YEAR, END_YEAR, 6:10, [5 25], [-45 -10]);

% Compute the pointwise correlations between SST and the storms
atlCorrGrid = pointRelate(seasonal, atlCounts, @rowCorr);
atlMICGrid = pointRelate(seasonal, atlCounts, @rowMIC);
eatlCorrGrid = pointRelate(seasonal, eatlCounts, @rowCorr);
eatlMICGrid = pointRelate(seasonal, eatlCounts, @rowMIC);

% Compute the correlation and MIC between the sst boxes and counts
atlBoxCorr = rowCorr(allBoxSST(:, 5:end), atlCounts);
atlBoxMIC = rowMIC(allBoxSST(:, 5:end), atlCounts);
eatlBoxCorr = rowCorr(allBoxSST(:, 5:end), eatlCounts);
eatlBoxMIC = rowMIC(allBoxSST(:, 5:end), eatlCounts);

% Sort the boxes and store the box corr/mic, limits, and timeseries
[ vals indices ] = sort(eatlBoxCorr, 'descend');
sortedEatlCorr = [ eatlBoxCorr(indices) allBoxSST(indices, :) ];
[ vals indices ] = sort(eatlBoxMIC, 'descend');
sortedEatlMIC = [ eatlBoxMIC(indices) allBoxSST(indices, :) ];
[ vals indices ] = sort(atlBoxCorr, 'descend');
sortedAtlCorr = [ atlBoxCorr(indices) allBoxSST(indices, :) ];
[ vals indices ] = sort(atlBoxMIC, 'descend');
sortedAtlMIC = [ atlBoxMIC(indices) allBoxSST(indices, :) ];

save('PreseasonResults.mat', 'sortedAtlCorr', 'sortedAtlMIC', ...
    'sortedEatlCorr', 'sortedEatlMIC', 'atlCounts', 'eatlCounts', 'dataLims' )

% Plot the east atlantic and atlantic best boxes

atlBox = [ 5 35 -100 -10 ];
eatlBox = [ 5 25 -45 -10 ];

bestEatlCorr = [ sortedEatlCorr(1:10, 1:5) repmat(eatlBox, 10, 1) ];
bestEatlMIC = [ sortedEatlMIC(1:10, 1:5) repmat(eatlBox, 10, 1) ];
bestAtlCorr = [ sortedAtlCorr(1:10, 1:5) repmat(atlBox, 10, 1) ];
bestAtlMIC = [ sortedAtlCorr(1:10, 1:5) repmat(atlBox, 10, 1) ];

%% PLOTTING THE BEST BOXES
fprintf('plotting boxes\n');

% Plot the ten best boxes
eatlCorrBoxPlots = plotBoxes(bestEatlCorr, [-30 50], [ -130 30 ]);
eatlMICBoxPlots = plotBoxes(bestEatlMIC, [-30 50], [ -130 30 ]);

atlCorrBoxPlots = plotBoxes(bestAtlCorr, [-30 50], [ -130 30 ]);
atlMICBoxPlots = plotBoxes(bestAtlMIC, [-30 50], [ -130 30 ]);
    
plotDir = 'boxPlots/';
if ~exist(plotDir, 'dir')
    mkdir(plotDir);
end
% Save the best box plots
for i = 1:10
    % Change the titles of the MIC plots
    title(get(eatlMICBoxPlots(i), 'CurrentAxes'), sprintf('Boxes with a MIC of %.02f', bestEatlCorr(i, 1)), 'FontSize', 12, 'Visible', 'on')
    title(get(atlMICBoxPlots(i), 'CurrentAxes'), sprintf('Boxes with a MIC of %.02f', bestAtlCorr(i, 1)), 'FontSize', 12, 'Visible', 'on')
    % Save the plots
    saveas(eatlMICBoxPlots(i), sprintf('%seatlMIC%02d.png', plotDir, i))
    saveas(eatlCorrBoxPlots(i), sprintf('%seatlCorr%02d.png', plotDir, i))
    saveas(atlMICBoxPlots(i), sprintf('%satlMIC%02d.png', plotDir, i))
    saveas(atlCorrBoxPlots(i), sprintf('%satlCorr%02d.png', plotDir, i))
end

    
