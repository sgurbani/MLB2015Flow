function features = getFeaturesFromSlide(fnm)
%%  This function returns a P x 1 column of features corresponding to a
%   given CSV filename.

%open the CSV file, ignoring the first row
M = csvread(fnm, 1, 0);

m = 3;  %features per protein
%get mean and standard deviation of each column as "features"
features = zeros(m * size(M,2),1);
for i=1:size(M,2)
    
    %mean and standard deviation
    features(i*m-2) = mean(M(:,i));
    features(i*m-1) = std(M(:,i));
    
    %count number of peaks in the sample
    features(i*m) = length( findpeaks(M(:,i), 'MinPeakProminence', 3) );
end

end