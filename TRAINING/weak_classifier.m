function [ t,T,e,M ] = weak_classifier( w, sample)
%% WEAK_CLASSIFIER function
%   This function finds the toggle, threshold, margin and corresponding error
%   of a particular feature. The threshold is obtained minimizing the
%   error.
% 
%   INPUT: 'w' : array containing the weight of every single image [1 x
%   num_images_in_the_trainingset];
%   'sample' : [2 x number_of_images] matrix containing for each image: the
%   feature value as computed by this function and its label (1 : face, -1:
%   non face).
% 
%   OUTPUT: 't' : the value of this feature's best threshold;
%   'T' : its corresponding toggle;
%   'e' : its corresponding error;
%   'M' : its corresponding margin.
% % % % % % %

%% Initializations
% create an array merging the computed feature value and the weights
sample_w = cat(1,sample,w);

% find all unique values of the feature
unique_values = unique(sample_w(1,:));

% find the total number of images
n = length(w);

% initialize an array containing all the unique values
% i.e. all the possible thresholds
thresholds = zeros (length(unique_values)+1,1);

% the first threshold must be lower than the lowest coputed feature value
thresholds(1) = (unique_values(1)-1); 

% initialize the array containing the margins 
margins = zeros (length(unique_values)+1,1);

% compute all the possible thresholds using the unique values of this
% feature, and the corresponding margins
if length(unique_values) > 1
    j = 2;
    for i = 1:(length(unique_values)-1)
        thresholds(j) = (unique_values(i) + unique_values(i+1))*0.5;
        margins(j) = unique_values(i+1) - unique_values(i);
        j = j + 1;
    end
    thresholds(j) = (unique_values(end)+1);
else
    thresholds = [(unique_values(1)-1); (unique_values(end)+1)];
end

% initialize error (e), margin (M), toggle (T)
e = 2;e_temp = e; M = 0;M_temp = M; T_temp = 1; T = T_temp;

%% Main loop
g = 1;
for j = 1:length(thresholds)
    % for every threshold in thresholds
    t_temp = thresholds(j);
    M_temp = margins(j);
    
    % initialize the error counters
    W1_plus = 0; W0_plus = 0; W1_minus = 0; W0_minus = 0;
    % 
    for i = 1:n
        if (sample_w(1,i) > t_temp)
            if (sample_w(2,i) == 1)
                W1_plus = W1_plus + sample_w(3,i);
            else
                W0_plus = W0_plus + sample_w(3,i);
            end
        else
            if (sample_w(2,i) == 1)
                W1_minus = W1_minus + sample_w(3,i);
            else
                W0_minus = W0_minus + sample_w(3,i);
            end
        end
    end
    %
    error_plus = W1_minus + W0_plus;
    error_minus = W1_plus + W0_minus;
    
    % find which error is lower to decide the toggle
    if error_plus < error_minus
        e_temp = error_plus;
        T_temp = 1;
    else
        e_temp = error_minus;
        T_temp = -1;
    end
    
    % if this threshold's error is lower than the current minimum error,
    % keep it as minimum error (= best threshold)
    if e_temp < e || (e_temp == e && M_temp > M)
        e = e_temp;
        t = t_temp;
        T = T_temp;
        M = M_temp;
    end
    
end

end