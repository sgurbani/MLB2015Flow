%%Perform Welch's t-test (for unequal sample sizes / variances) to see
%%which features most reliably separate Normal and AML cases

%load training data
load TrainingData.mat;

%separate XTrain into X0 (normal) and X1 (AML)
X0 = XTrain( :, find( YTrain == 0 ) );
X1 = XTrain( :, find( YTrain == 1 ) );

%go through each feature and get T-values
T = zeros( size(XTrain, 1), 1 );

for i=1:size(XTrain, 1)
    [h p ci stats] = ttest2( X0(i,:), X1(i,:), 'VarType', 'unequal');
    T(i) = abs( stats.tstat );
end

%get top 25 features
[~, inds] = sort(T,1,'descend');

T100 = inds(1:100);
XTrainTop100_Y = [XTrain(T100,:); YTrain'];
save TrainingData_Top100;

T50 = inds(1:50);
XTrainTop50_Y = [XTrain(T50,:); YTrain'];
save TrainingData_Top50;

T25 = inds(1:25);
XTrainTop25_Y = [XTrain(T25,:); YTrain'];
save TrainingData_Top25;

XTrain_Y = [XTrain; YTrain'];
save TrainingData_All;

% svmmodel = fitcsvm(XTrain', YTrain);
% CV = crossval(svmmodel, 'KFold', 10);