% % %%%%%%%%%%%%%%%%%%%%%%
% % % % MAIN SCRIPT % % %
% %%%%%%%%%%%%%%%%%%%%%%%%

diary('myTextLog2.txt');
%
clear variables
clc

% Initializations

%select a number of validation and training images
numValid = 1000; numTrain = 1000;
% 
% select the maximum accepted FINAL False Positive rate
% gamma_zero = 0.0001;

% select maximum accepted False Positive rate for each level of the Cascade
gamma_l = 0.50;

% select the maximum accepted False Negative rate for each leve of the
% Cascade
beta_l = 0.02;
dec_rate = 1 - beta_l; 

% initialize the loop variables and counters
gamma_zero_temp = 1; c = 1; l = 1;

% initialize the cell array that will contain your final Cascade
% it must be 2xnumber_of_expected_layers (we will leave 40)
cascade = cell(2,40);

% run the function that creates the indexes for all the features
inds = parameters();

%% Data set load
fprintf(' Select facedata: \n\n');
pause
directory_facedata = uigetdir('');
%
directory_faces = sprintf('%s//faces//',directory_facedata);
directory_nonfaces = sprintf('%s//nonfaces//',directory_facedata);
directory_train = sprintf('%s//trainImages//',directory_facedata);
directory_valid = sprintf('%s//validImages//',directory_facedata);

%% Randomly pick images from your dataset
% load training and validation sets for positive images (24x24)
images_train_pos = random_load(directory_faces, numTrain);
images_valid_pos = random_load(directory_faces, numValid);

% load THE INITIAL training and validation sets for negative images (24x24)
% if you want to have a bigger set of negatives for the first iteration, it 
% is required to use another cell ""_iniz"
images_train_iniz_neg = random_load(directory_nonfaces, numTrain);
images_valid_iniz_neg = random_load(directory_nonfaces, numValid);

% load the negative images from which to draw the subsequent negative
% images (various dimensions)
train_neg = random_load(directory_train, 500);
valid_neg = random_load(directory_valid, 500);

% Compute the Integral Images
[ II_train_pos, ~] = int_image(images_train_pos);
[ II_valid_pos, ~] = int_image(images_valid_pos);
[ II_train_neg, ~] = int_image(images_train_iniz_neg);
[ II_valid_neg, ~] = int_image(images_valid_iniz_neg);
II_train_iniz_neg = II_train_neg;

% clear unused variables
clear -regexp ^directory ^images_

% MAIN LOOP: Cascade Training
% % % % % ---------------------- % % % % % %
% run until wanted performance is obtained

% while gamma_zero_temp > gamma_zero 
while l<16
    %% initialize timer and print current iteration
    tStart = tic;
    fprintf('Livello Cascata: %1d\n\n', l);
    
    % initialize NL = max size (number of features) of this layer's strong
    % classifier
    NL = min (10*l+10,200);
    
    % extract the size of the whole dataset and use it to initialize the
    % adaboost weights
    sizeSet = size(II_train_pos,2) + size(II_train_neg,2);
    weights = zeros(1,sizeSet) + 1/(sizeSet);
    
    % initialize the strong classifier's size 
    TL = 1;
    
    % initialize flag
    flag = 0;
    
    %% ADABOOST LOOP
    % runs until wanted performances are reached (flag becomes 1)
    while (TL < NL && flag ==0)
        % print adaboost current iteration and set up timers
        fprintf('>>>>>>> Adaboost: %1d <<<<<<<\n', TL);
        time1a = toc(tStart);
        
        % run the adaboost function
        [ stump(TL,:), weights] = adaboost( weights, inds, II_train_pos, II_train_neg );
        
        % run the shift_classifier function
        [ shift,gamma_l_temp, beta_l_temp, flag ] = shift_classifier( stump, gamma_l, beta_l, II_train_pos, II_valid_pos, II_train_neg, II_valid_neg );
        save('adaboost.mat', 'weights', 'shift', 'gamma_l_temp', 'beta_l_temp');
        % update strong classifier's size
        TL = TL + 1;
        
        % print time info and current performances
        time1b = toc(tStart);
        fprintf('Adaboost: %d, completed in %s \n', TL-1,seconds(time1b-time1a));
        fprintf('gamma: %2.4f, beta: %2.4f\n$$$$$$\n', gamma_l_temp,beta_l_temp);
    end
    % save the obtained strong classifier (stump) in this layer of the cascade with it's
    % corresponding shift value (shift)
    cascade{1,l} = stump; cascade{2,l} = shift;
    
    % clear current stump (should be redundant)
    clear stump
    
    % update global False Positive rate (gamma_zero_temp)
    gamma_zero_temp = gamma_zero_temp*gamma_l_temp;
    
    %% Run the current cascade on validation and training images
    % the false positives will be saved and used as training and validation
    % sets for the subsequent training level
    
    % print time info and set up timers
    time2 = toc(tStart);
    fprintf('Cascade round: %d, completed in %s \n', l,minutes((time2)/60));
    fprintf('gamma: %2.4f, beta: %2.4f, shift: %1.3f\n', gamma_l_temp, beta_l_temp, shift);
    time3a = toc(tStart);
    
    % run findFP to obtain false positives
    [ II_train_neg, II_valid_neg ] = findFP( cascade, train_neg, valid_neg, numTrain );
    
    % print time info (if everything works, this should take longer every
    % iteration)
    time3b = toc(tStart);
    fprintf('Found %d new negatives in %s \n', numTrain,minutes((time3b-time3a)/60));
    fprintf('------------------------------------------------------\n\n');
    
    % update cascade iterator
    l = l + 1;
end
save('workspace.mat', 'gamma_l', 'beta_l', 'cascade', 'numTrain', 'numValid');
diary('off');
