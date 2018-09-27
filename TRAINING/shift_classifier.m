function [ shift,gamma_l_temp, beta_l_temp, result ] = shift_classifier( classifier, gamma_l, beta_l, II_train_pos, II_valid_pos, II_train_neg, II_valid_neg )
%% SHIFT_CLASSIFIER function
%   This function tries to shift the strong classifier obtained from the
%   adaboost function, to see if it meets the required performances.
%
%   INPUT: 'classifier': the strong classifier obtained from adaboost [10 x num_weak_classifiers];
%   'gamma_l': maximum false positive rate accepted;
%   'beta_l' : max false negative rate accepted;
%   'II_train_pos, II_valid_pos, II_train_neg, II_valid_neg' : cell arrays containing the integral
%   images of validation and training positives and negatives [1 x num_of_images].
%
%   OUTPUT: 'gamma_l_temp' : the best FP rate found with the shift
%   function;
%   'beta_l_temp' : the best FN rate found with the shift function;
%   result : a toggle that will be set to 1 if the wanted performances are
%   obtained;
%   'shift' : the value of the best shift, if the performances were met.
% % % % % % %

%% Initializations 

% 'u' is a variable used to prevent the algorythm from going back and forth
% between two values of the shift
u = 0.01; s(1) = 0; i = 1;
result = 0;
%
%% Main Loop
%
while u > 10^(-5) && result ==0
    % run shifted classifier
    shift = s(i);
    
    % run use_shifted_classifier to obtain the current shift's performances
    [ gamma_l_temp, beta_l_temp ] = use_shifted_class( classifier, shift, II_train_pos, II_valid_pos, II_train_neg, II_valid_neg);
    
    % if results are accettable, result == 1; otherwise try another shift
    % value
    if (gamma_l_temp <= gamma_l && (1-beta_l_temp) >= (1-beta_l))
        shift = s(i);
        result = 1;
    elseif gamma_l_temp <= gamma_l && (1-beta_l_temp) < (1-beta_l)
        % improve detection rate
        s(i+1) = s(i) + u;
        % use the monotone function to see if s is monotone
        monot = monotone(s);
        if monot == 0
            u = u/2;
            s(i+1) = s(i) - u;
        end
    elseif gamma_l_temp > gamma_l && (1-beta_l_temp) >= (1-beta_l)
        % improve the false positive rate
        s(i+1) = s(i) - u;
        monot = monotone(s);
        if monot == 0
            u = u/2;
            s(i+1) = s(i) + u;
        end
    else
        s(i+1) = 0;
        u = 10^(-6);
    end
    i = i + 1;
end

% redundant: if performances were not met, run the use_shifted_classifier
% function again with shift = 0 to prompt this value during the cascade
% training main loop
if result == 0
    [ gamma_l_temp, beta_l_temp ] = use_shifted_class( classifier, 0, II_train_pos, II_valid_pos, II_train_neg, II_valid_neg);
end
 % 

end

