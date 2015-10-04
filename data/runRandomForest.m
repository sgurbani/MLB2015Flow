clear; clc;

%minimum leaf size - stopping criterion for a leaf
minLeaf = 1;

%number of features to sample (w/o replacement) at each node
M = 150;

%number of trees
N = 100;

%start parallel pool
if isempty(gcp('nocreate'))
    parpool;
end
opt = statset;
opt.UseParallel = true;

%load Training Data
load TrainingData.mat;
load TestingData.mat;

%separate by class
X0 = XTrain(:, find(YTrain==0) )';
X1 = XTrain(:, find(YTrain==1) )';

% 5x cross validation, num iterations
numIter = 50;

%accuracy, precision, and recall
acc = zeros(numIter, 1);
prec = zeros(numIter, 1);
rec = zeros(numIter, 1);

%train set fraction
tsf = 0.8;
% 
% %do cross validation
% for k=1:numIter
%     %randomly sample 1/5th of the data
%     trainInds0 = randperm( size(X0,1), round(tsf*size(X0,1)) )';
%     testInds0 = setdiff( 1:size(X0,1), trainInds0 )';
%     
%     trainInds1 = randperm( size(X1,1), round(tsf*size(X1,1)) )';
%     testInds1 = setdiff( 1:size(X1,1), trainInds1 )';
%     
%     trainInds = vertcat(trainInds0, trainInds1);
%     testInds = vertcat(testInds0, testInds1);
%     
%     XTrain_fold = XTrain(:, trainInds)';
%     YTrain_fold = YTrain(trainInds);
%     XTest_fold = XTrain(:, testInds)';
%     
%     %Train the random forrest
%     entmoot = TreeBagger( N, XTrain_fold, YTrain_fold, ...
%         'SampleWithReplacement', 'on', ...
%         'MinLeafSize', minLeaf, ...
%         'NVarToSample', M, ...
%         'Prior', 'Empirical', ...
%         'Options', opt, ...
%         'Method', 'classification' );
%     
%     %predict on the test set
%     Yhat = predict(entmoot, XTest_fold);
%     Yhat_str = [Yhat{:}];
%     
%     %true answers
%     Ytest_str = strrep([num2str(YTrain(testInds)')],' ','');
%     
%     acc(k) = length(find(Yhat_str == Ytest_str)) / length(Yhat_str);
%     prec(k) = length( find(Yhat_str == '1' & Ytest_str == '1') ) / length(find(Yhat_str == '1'));
%     rec(k) = length( find(Yhat_str == '1' & Ytest_str == '1') ) / length(find(Ytest_str == '1'));
% end
% 
% fprintf('Mean accuracy: %.4f\nMin accuracy: %.4f\n',mean(acc), min(acc));
% fprintf('Mean precision: %.4f\nMin precision: %.4f\n',mean(prec), min(prec));
% fprintf('Mean recall: %.4f\nMin recall: %.4f\n\n',mean(rec), min(rec));
% 
% allStats = [mean(acc) min(acc) mean(prec) min(prec) mean(rec) min(rec)];

%Build the forest with everyone
entmoot = TreeBagger( N, XTrain', YTrain, ...
        'SampleWithReplacement', 'on', ...
        'MinLeafSize', minLeaf, ...
        'NVarToSample', M, ...
        'Prior', 'Empirical', ...
        'Options', opt, ...
        'Method', 'classification' );
    
%Load the testing data
% load TestingData.mat;

%Predict
YHat = predict( entmoot, XTest');
Yhat_str = [YHat{:}];