function testIsEncompassing( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

addpath('/project/expeditions/haasken/matlab/OptimizeCorr/')

testOuterBoxes = [ ...
    5 20 10 70; ...
    0 20 10 70; ...
    -10 10 20 110; ... 
    -10 10 20 110; ...
    5 20 150 -150; ...
    5 20 150 -150; ...
    5 20 150 170; ...
    5 20 -90 90;
    ];


testInnerBoxes = [ ...
    10 20 20 30;
    0 10 10 50; ...
    -10 0 50 60; ...
    5 30 100 110; ...
    5 10 160 -160; ... 
    15 20 -170 -140; ... 
    5 10 160 -170; ...
    5 20 45 -45;
    ];

expectedResults = [ 1 1 1 0 1 0 0 0 ];

numTests = size(testOuterBoxes, 1);

testResults = false(1, numTests);

for i = 1:numTests
    outerBox = testOuterBoxes(i, :);
    innerBox = testInnerBoxes(i, :);
    
    testResults(i) = isEncompassing(outerBox, innerBox);

end

assert(all(testResults == expectedResults));

end