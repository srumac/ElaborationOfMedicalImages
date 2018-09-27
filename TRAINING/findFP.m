function [ II_train_neg, II_valid_neg ] = findFP( cascade, train_neg, valid_neg, n )
%% FIND_FP function
%   This function runs the current cascade and saves all the positive
%   subwindows.
%
%   INPUT: 'cascade': the cell array containing all the strong classifiers [2 x 60];
%   'train_neg': negative images of various dimensions used for training [1 x number_of_negatives];
%   'valid_neg': negative images of various dimensions used for validation [1 x number_of_negatives];
%   'n': the number of positive subwindows we want to find.
%
%   OUTPUT: 'II_train_neg, II_valid_neg' : the integral images of the
%   positive subwindows from the two datasets; [1 x number_of_negatives].
% % % % % % %

%% Initializations

% extract the number of images in your datasets
a = size(train_neg,2); b = size(valid_neg,2);

% to choose randomly from the dataset, use randperm
h1 = randperm(a); h2 = randperm(b);

% initialize 'false_pos_train' and 'false_pos_val' as cell arrays (needed
% for the cat() function)
false_pos_train = cell(1,1); false_pos_val = cell(1,1);

%% Find the false positives from the validation set

% initialize the counters
k = 0; remain = n;
while k < n
    %
    % take the first random image from the dataset
    h = h2(end);
    
    % delete its index, to not use it again
    h2(end) = [];
    
    %
    img = valid_neg{h};
    
    % run use_cascade to find the remaining positives
    [yy, ~, f] = use_cascade(cascade, img, remain);
    
    % merge the found positves with the ones found before
    false_pos_val = cat(2, false_pos_val, yy);
    
    % 'k' is the number of found positives; add the number of positives
    % found at this iteration
    k = k + f ;
    
    % 'remain' is the number of remaining positives to find
    remain = n - k;
end
% 
% delete the first cell of the array (empty)
false_pos_val(1) = [];

%% Find the false positives from the training set
% same process as above, with the training set
%
k = 0; remain = n;

while k < n
    h = h1(end);
    h1(end) = [];
    img = train_neg{h};
    [xx, ~, f] = use_cascade(cascade, img, remain);
    false_pos_train = cat(2, false_pos_train, xx);
    k = k + f;
    remain = n - k;
end
%
false_pos_train(1) = [];
%
%% Reshape all subwindows to 24 x 24 images using imresize
%
for kk = 1:n
    %
    if size(false_pos_train{kk}, 1) > 24
        false_pos_train{kk} = imresize(false_pos_train{kk}, 24);
    end
    %
    if size(false_pos_val{kk}, 1) > 24
        false_pos_val{kk} = imresize(false_pos_val{kk}, 24);
    end
    %
end
%
% use int_image to compute the integral images of the datasets
II_train_neg = int_image(false_pos_train);
II_valid_neg = int_image(false_pos_val);

end

