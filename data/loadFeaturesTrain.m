%%This script will load all feature data from CSV files
clear; clc;

%number of features
P = 448;    %8 tubes * 7 proteins/tube * 8 features/protein

%number of training patients
Ntrain = 179;

%number of testing patients
Ntest = 180;

%initialize training data matrix
XTrain = zeros( P, Ntrain );

%go through all slides
load Labels.mat;    %has the filenames of all training data
load FlowNames.mat; %has the proteins in each tube

%%TRAINING DATA
% for i=1:length(FilenamesTrain)
%     %get the filename and convert it to an integer
%     fnm = FilenamesTrain{i};
%     fnmInt = str2num(fnm);
%     
%     %get the patient and tube number
%     ptNum = ceil( fnmInt / 8 );
%     tubeNum = mod( fnmInt, 8 );
%     if tubeNum == 0
%         tubeNum = 8;
%     end
%     
%     %get features from this CSV file
%     features = getFeaturesFromSlide( [pwd '/CSV/' fnm '.csv'] );
%     
%     %place into the appropriate rows of Xtrain
%     XTrain( (tubeNum-1)*length(features)+1 : tubeNum*length(features) ...
%         , ptNum ) = features;
% end
% 
% %generate feature names - 5 bins per protein
% FeatureNames = cell(P,1);
% for r=1:8   %8 tubes
%     for c=1:7   %7 proteins per tube
%         for s=1:8   %8 features per protein
%             if s==1
%                 FeatureNames{ (r-1)*56+(c-1)*8 + s } = ['Tube' num2str(r) '_' FlowNames{r,c} '_mean'];
%             elseif s==2
%                 FeatureNames{ (r-1)*56+(c-1)*8 + s } = ['Tube' num2str(r) '_' FlowNames{r,c} '_std'];
%             elseif s==3
%                 FeatureNames{ (r-1)*56+(c-1)*8 + s } = ['Tube' num2str(r) '_' FlowNames{r,c} '_numPeaks'];
%             else
%                 FeatureNames{ (r-1)*56+(c-1)*8 + s } = ['Tube' num2str(r) '_' FlowNames{r,c} '_bin' num2str(s-3)];
%             end
%         end
%     end
% end
% 
% save TrainingData XTrain YTrain FeatureNames;


%%TESTING DATA
XTest = zeros( P, Ntest );
for i=1:length(FilenamesTest)
    %get the filename and convert it to an integer
    fnm = FilenamesTest{i};
    fnmInt = str2num(fnm);
    
    %get the patient and tube number
    ptNum = ceil( fnmInt / 8 ) - Ntrain;
    tubeNum = mod( fnmInt, 8 );
    if tubeNum == 0
        tubeNum = 8;
    end
    
    %get features from this CSV file
    features = getFeaturesFromSlide( [pwd '/CSV/' fnm '.csv'] );
    
    %place into the appropriate rows of Xtest
    XTest( (tubeNum-1)*length(features)+1 : tubeNum*length(features) ...
        , ptNum ) = features;
end

save TestingData XTest FeatureNames;