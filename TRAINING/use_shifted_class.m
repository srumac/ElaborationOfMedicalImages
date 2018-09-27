function [ gamma_temp, beta_temp] = use_shifted_class( classifier, s, II_train_pos, II_valid_pos, II_train_neg, II_valid_neg)
%% USE_SHIFTED_CLASSIFIER function
%   This function runs the shifted classifier and obtains its performances.
% 
%   INPUT: 'classifier': the strong classifier obtained from adaboost [10 x num_weak_classifiers];
%   's': the shift value to evaluate;
%   'II_train_pos, II_valid_pos, II_train_neg, II_valid_neg' : the integral
%   images of validation and training positives and negatives [1 x number_of_training_images].
% 
%   OUTPUT: 'gamma_temp' : the FP rate found with this shift value;
%   'beta_l_temp' : the FN rate found with this shift value.
% % % % % % %

%% Initializations 
% number of features to be evaluated in this layer
numFeatures = size(classifier,1); 

% initialize the class array, containing our classification
class_train = zeros(1,numFeatures); 
class_valid = zeros(1,numFeatures);

% initialize counters
i = 1;
VPt = 0; FPt = 0; FNt = 0; VNt = 0;
VPv = 0; FPv = 0; FNv = 0; VNv = 0;

%%  Main Loop 
% 
while i <= size(II_train_pos,2)  
    
    % 'x' is the current image of the training positives; y for validation
    x = II_train_pos{i};
    y = II_valid_pos{i};
    
    % initialize the summations ('a' and 'b')
    a = 0; b = 0;
    
    for j = 1:numFeatures
        % for all the weak classifiers (features): j
        
        % the 10th element of this array contains the feature weight
        alpha = classifier(j,10); 
        
        % run use_weak_classifier on x to obtain the classification
        class_train(j) = use_weak_classifier(classifier(j,:), x, 24);
        
        % sum the results of all weak classifiers, plus shift to the strong
        % classifier (i.e. the sum of weak classifiers)
        a = a + (class_train(j) + s)*alpha;
       
        % do the same for y
        class_valid(j) = use_weak_classifier(classifier(j,:), y, 24);
        b = b + (class_valid(j) + s)*alpha;
    end
    
    % use the strong classifier to classify this image
    index_train = sign(a); 
    index_valid = sign(b);
    
    % confront the result with the original label, and increas FN, VP
    % counters
    if index_train == 1
        VPt = VPt + 1;
    else
        FNt = FNt + 1;
    end
    %
    if index_valid == 1
        VPv = VPv + 1;
    else
        FNv = FNv + 1;
    end
    i = i + 1;
    % 
end

%% Do the same as above with the negative training and validation set
i = 1;
class_train = zeros(1,numFeatures); 
class_valid = zeros(1,numFeatures);
while i <= size(II_train_neg,2) 
    x = II_train_neg{i};
    y = II_valid_neg{i};
    %
    a = 0; b = 0;
    % 
    for j = 1:numFeatures
        alpha = classifier(j,10);
        %
        class_train(j) = use_weak_classifier(classifier(j,:), x, 24);
        a = a + (class_train(j) + s)*alpha;
        %
        class_valid(j) = use_weak_classifier(classifier(j,:), y, 24);
        b = b + (class_valid(j) + s)*alpha;
    end
    index_train = sign(a); 
    index_valid = sign(b);
    
    % confront the result with the original label, and increas FP, VN
    % counters
    if index_train == 1
        FPt = FPt + 1;
    else
        VNt = VNt + 1;
    end
    if index_valid == 1
        FPv = FPv + 1;
    else
        VNv = VNv + 1;
    end
    
    i = i + 1;
    %
end

% keep the max FP and FN rate between validation and training set (worst
% case scenario)
gamma_temp = max(FPt/(FPt+VNt),FPv/(FPv+VNv));
beta_temp = max(FNt/(FNt+VPt),FNv/(FNv+VPv));
% 
end

