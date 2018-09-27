function [ best_stump,w_next ] = adaboost( w, index, F, NF )
%% ADABOOST function
%   This function uses the Adaboost algorithm to find the best weak
%   classifier to separate a dataset in 'faces' and 'not faces'.
%
%   INPUT: 'w' : an array containing the weights of every image; for the
%   first round, all images have the same weight, later images that were
%   misclassified previously have a bigger weight [1 x num_images_in_the_trainingset];
%   'index' : a matrix containing the indexes of all the features [141600 x 5];
%   'F' , 'NF' : cell arrays containinf the integral images of positive (F)
%   and negative (NF) training set [1 x number_of_training_images];
%
%   OUTPUT: 'best_stump' : the best weak classifer, and its weight
%   (proportional to its error) [10 x 1];
%   'w_next' : the updated weights, used to run the algorithm the next
%   iteration [ size of w ];
%   
% % % % % % %

%% Initializations

% extracts the total number of features and the number of samples in the dataset
numFeatures = size(index,1); numSamples = size(w,2);

% initialize the vectors containing the parameters of each feature
% t : threshold; M : margin; e : error; T : toggle value (-1,1)
t_t = zeros(1,numFeatures); M_t = zeros(1,numFeatures); e_t = zeros(1,numFeatures); T_t = zeros(1,numFeatures);

% initialize the array containing the best_stump
best_stump = zeros(10, 1);

% initialize the array containing the updated weights
w_next = zeros(1, numSamples);

%% Adaboost: Find the best weak classfier 

% for every feature
parfor n = 1:numFeatures
    % compute the current feature value for each element in the dataset
    val_1 = nth_feature(index(n,:) , F, 1);
    val_2 = nth_feature(index(n,:) , NF, -1);
    
    % merge the positive and negative arrays
    g = cat(2,val_1,val_2);
    
    % run 'weak_classifier' to find threshold, toggle, error and margin of this feature
    [ t_t(n),T_t(n),e_t(n),M_t(n)] = weak_classifier(w , g);
    
end

%% Find minimum error, save its data in best_stump (with its weight alpha)
% the minimum error corresponds to the feature that best divides the
% dataset in 'faces' and 'nonfaces'

min_e = find(e_t == min(e_t));
% if 2 or more features have the same error, take the one with greater
% margin; if they have the same margin, they are equal: take the first one
% in the array
if length(min_e) > 1
    temp = M_t(min_e);
    min_m = temp == max(temp);
    min_ind = min_e(min_m);
else
    min_ind = min_e;
end

%% ERROR = 0
% if one of the feature has null error, take the one with the lowest yet >0
% error and prompt a warning; if this case occurs, probably the dataset is
% too little

if e_t(min_ind(1)) == 0
    save('nullerror.mat', 'e_t', 'min_ind');
    error = min(e_t(e_t > 0));
    fprintf('warning: null error \n\n');
else
    error = e_t(min_ind(1));
end

% save the best classifier's parameters
M = M_t(min_ind(1)); T = T_t(min_ind(1)); t = t_t(min_ind(1));

% compute alpha, which will be used as a weight in the strong classifier
beta = error/(1-error);
alpha = 0.5*(log(1/beta));

% save the stump (classifier)
best_stump(1:5) = index(min_ind(1), 1:5);
best_stump(6:10) = [t, T, error, M, alpha ];

%% Weight update and normalization
% compute again the value of the best feature on all the dataset
val_1 = nth_feature(index(min_ind(1),:) , F, 1);
val_2 = nth_feature(index(min_ind(1),:) , NF, -1);
s = cat(2,val_1,val_2);

% run the classify function to obtain 'p', used to update the weights
p = classify(s,T,t); 

% update the weights: misclassified samples will have a bigger weight in
% subsequent iterations of the adaboost routine
for i = 1:numSamples
    w_next(i) = (w(i)*0.5)*( ((1/error)*(1-p(i))) + ((1/(1-error))*(p(i))));
end

% normalize the weights: the sum must always be 1
w_next = w_next ./ sum(w_next);
end

