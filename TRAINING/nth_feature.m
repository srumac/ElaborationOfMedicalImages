function [ values ] = nth_feature( ind,sample,toggle )
%% NTH_FEATURE function
%   This function computes one feature for all the images contained in
%   'sample' and creates a matrix [2 x number_of_images], with the computed
%   feature value and a toggle (1 : face, -1 : non face).
% 
%   INPUT: 'ind': containing the feature type and its indexes [feature_type,i,j,h,w];
%   'sample': cell array containing the integral images [1 x number_of_images];
%   'toggle' : 1 for faces, -1 for non faces; [1 x number_of_images].
% 
%   OUTPUT: 'values' : matrix containing for each image: the
%   feature value as computed by this function and the corresponding toggle
%   [2 x number_of_images].
% % % % % % %

%% Initializations

% extract the total number of images in the dataset
imgNumber = size(sample,2);

% initialize output matrix
values = zeros (2,imgNumber);

% extract the parameters of the current feature
i = ind(2); j = ind(3); h = ind(4); w = ind(5);

% 
for k = 1:imgNumber
    
    % XX is the current integral image
    XX = sample{k};
    
    % label this image using its toggle
    values(2,k) = toggle;
    
    % compute the feature
    switch ind(1)
        case 1
                S1 = XX(i+h-1,j+w-1) + XX (i-1,j-1) - XX(i-1,j+w-1) - XX(i+h-1,j-1);
                S2 = XX(i+h-1,j+2*w-1) +  XX(i-1,j+w-1) - XX(i-1,j+2*w-1) - XX(i+h-1,j+w-1);
                values(1,k) = S1 - S2;
        case 2
                S1 = XX(i+h-1,j+w-1) + XX (i-1,j-1) - XX(i-1,j+w-1) - XX(i+h-1,j-1);
                S2 = XX(i+h-1,j+2*w-1) +  XX(i-1,j+w-1) - XX(i-1,j+2*w-1) - XX(i+h-1,j+w-1);
                S3 = XX(i+h-1,j+3*w-1) +  XX(i-1,j+2*w-1) - XX(i-1,j+3*w-1) - XX(i+h-1,j+2*w-1) ;
                values(1,k) = S1 - S2 + S3;
        case 3
                S1 = XX(i+h-1,j+w-1) + XX (i-1,j-1) - XX(i-1,j+w-1) - XX(i+h-1,j-1);
                S2 = XX(i+2*h-1,j+w-1) +  XX(i+h-1,j-1) - XX(i+h-1,j+w-1) - XX(i+2*h-1,j-1) ;
                values(1,k) = S1 - S2;
        case 4
                S1 = XX(i+h-1,j+w-1) + XX (i-1,j-1) - XX(i-1,j+w-1) - XX(i+h-1,j-1);
                S2 = XX(i+2*h-1,j+w-1) +  XX(i+h-1,j-1) - XX(i+h-1,j+w-1) - XX(i+2*h-1,j-1) ;
                S3 = XX(i+3*h-1,j+w-1) +  XX(i+2*h-1,j-1) - XX(i+2*h-1,j+w-1) - XX(i+3*h-1,j-1) ;
                values(1,k) = S1 - S2 + S3;
    end
end


end

