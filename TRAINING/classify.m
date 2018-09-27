function [ p ] = classify( g,T,t )
%% CLASSIFY function
%   This function creates an array where '1' corresponds to an image that
%   has been correctly classified, and '0' means misclassification
%
%   INPUT: 't', 'T': best threshold (with its toggle) as found in the
%   adaboost function;
%   'g' : the feature value computed on the whole dataset.
%
%   OUTPUT: 'p' : an array where 1 = correctly classified image, and 0 =
%   incorrectly classified image; [1 x num_of_images].
% % % % % % %

%% Initializations

% initialize the output array
p = zeros(1,size(g,2));

% initialize an array containing the classification of our stump
class_temp = zeros(1,size(g,2));

for i = 1:size(g,2)
    % if the feature value is above the threshold, the image contains a
    % face
    if g(1,i)*T > T*t
        class_temp(1,i) = 1;
    else
        class_temp(1,i) = -1;
    end
    %     
    if g(2,i) == class_temp(1,i)
        % if the real label of the image corresponds to the stump's
        % classification, we have a true positive (1)
        p(1,i) = 1;
    else
        p(1,i) = 0;
    end
end


end

