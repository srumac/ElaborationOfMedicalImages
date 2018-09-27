function [ P,index_P,n ] = use_cascade( cascade, img , num_FP)
%% USE_CASCADE function
%   This function uses the cascade to classify an image; 
%   it evaluates all the subwindows, after breaking it in subwindows 
%   increasing dimension: [dim = 24*1.5*iteration]. Every positive
%   subwindows is saved in a cell array (P), with its indexes (index_P) and
%   the number of found positive windows (n).
% 
%   INPUT: 'cascade' : the cell array where every cell is a strong
%   classifier as found from the adaboost routine [2 x 40];
%   'img' : the image; it can be of [any dimension];
%   'num_FP' : [OPTIONAL] the number of positive subwindows you want to find; 
%   if you use the cascade on one single 24x24 subwindow, don't set this
%   parameter.
% 
%   OUTPUT: 'P' : a cell array containing the positive subwindows (faces)
%   [1 x num_FP]; if the cascade finds less than num_FP positive
%   subwindows, the dimension will be [1 x number_of_found_positives];
%   'index_P' : the cell array containing the indexes to all the positive
%   subwindows [same dimensions as P];
%   'n' : the number of found positives is also given as an output.
% % % % % % %

% if num_FP is not given, set it at one (to run the cascade on one single
% 24x24 image)
if ~exist('num_FP','var')
    num_FP = 1;
end

%% Initializations

% initialize the subwindow scaling factor
c = 1.5; 

% initialize the first subwindow dimension
dim = 24; 

% initialize the counter and the cell arrays containing the positive
% subwindows(P), and its parameters (index_p)
n = 1; P = cell(1,num_FP); index_P = cell(1,num_FP);

% find the maximum subwindow dimension
max_length = min(size(img,1),size(img,2));

%% Main Loop
while (dim <= max_length && n <= num_FP)
    % for every dimension of subwindow (dim), break the image
    
    % run the break_img function to find the subwindows of 'dim' dimension
    % (A), and their indexes (B)
    [A,B] = break_img(img,dim, 0.04);
    %
    i = 1;
    while (i <= size(A,2) && n <= num_FP) 
        % size(A,2) is the number of subwindows of dimension dim
        
        % keep the original image to visualize progress
        x = A{i}; 
        
        % compute its integral image and standard deviation
        [ y, devstan ] = int_image(x);
        
        if devstan > 0.01
            
            for k = 1:size(cascade,2)
                % for all the strong classifiers in the cascade
                
                % save the current strong classfier and its shift
                layer = cascade{1,k}; 
                shift = cascade{2,k};
                
                % extract the number of features to be evaluated in this layer
                num_features = size(layer,1);
                
                % initialize the summation (a) to zero and the class array
                a = 0;
                class = zeros(1,num_features); 
                %
                for j = 1:num_features
                    % for all the weak classifiers (features): j
                   
                    % the 10th element of this array contains the feature weight
                    alpha = layer(j,10);
                    
                    % run use_weak_classifier on x to obtain the classification
                    class(j) = use_weak_classifier(layer(j,:), y, dim);
                    
                    % sum the results of all weak classifiers, plus shift to the strong
                    % classifier (i.e. the sum of weak classifiers)
                    a = a + (class(j) + shift)*alpha;
                end
                
                % use the strong classifier to classify this window
                index(k) = sign(a);
                %
                % when one layer sets this image as negative, no
                % further evaluation is required
                if index(k) == -1
                    break;
                end
                %
            end
            
            % if all the layer set this subwindows as positive, add it to the
            % positive array (and its indexes)
            if sum(index == -1) == 0
                P{n} = x;
                index_P{n} = B{i}; 
                n = n + 1;
            end
            
            % clear the index array
            clear index;
        end
        i = i + 1;
    end
    % set the subwindow dimension for the next round
    dim = floor(dim*c);
    %
end

%% If the algorithm did not find num_FP positives, delete the empty cells of the array
P(n:end) = [];
index_P(n:end) = [];
n = n - 1;

end

