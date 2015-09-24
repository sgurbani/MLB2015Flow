function features = getFeaturesFromSlide(fnm)
%%  This function returns a P x 1 column of features corresponding to a
%   given CSV filename.

%open the CSV file, ignoring the first row
M = csvread(fnm, 1, 0);

%get mean and standard deviation of each column as "features"
features = zeros(2 * size(M,2),1);
for i=1:size(M,2)
    features(i*2-1) = mean(M(:,i));
    features(i*2) = std(M(:,i));
end

end