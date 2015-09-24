%%This script will load all feature data from CSV files

%number of features
P = 112;    %8 tubes * 14 features / tube

%number of training patients
Ntrain = 179;

%number of testing patients
Ntest = 180;

%initialize training data matrix
XTrain = zeros( P, Ntrain );

%go through all slides
load Labels.mat;    %has the filenames of all training data

for i=1:length(FilenamesTrain)
    %get the filename and convert it to an integer
    fnm = FilenamesTrain{i};
    fnmInt = str2num(fnm);
    
    %get the patient and tube number
    ptNum = ceil( fnmInt / 8 );
    tubeNum = mod( fnmInt, 8 );
    if tubeNum == 0
        tubeNum = 8;
    end
    
    %get features from this CSV file
    features = getFeaturesFromSlide( [pwd '/CSV/' fnm '.csv'] );
    
    %place into the appropriate rows of Xtrain
    XTrain( (tubeNum-1)*length(features)+1 : tubeNum*length(features) ...
        , ptNum ) = features;
end
    
%remove extra variables
clearvars features Filenames* fnm* i Nt* P ptN* tubeNum;

save('TrainingData.mat');