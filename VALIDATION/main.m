%% Main Script for Validation %%%
clc 
close all
clearvars

%Initializations
TP = zeros(1, 20);
TN = zeros(1, 20);
FP = zeros(1, 20);
FN = zeros(1, 20);
Accuracy = zeros(1, 20);
Precision = zeros(1, 20);
Sens= zeros(1, 20);
Spec = zeros(1, 20);
load('cascade_finale') %Load Cascade

%for all the 20 images, do validation
 for i = 1:20
       filename = uigetfile('*.jpg');
       I = imread(filename);
       I=imresize(I, 0.5);
       f = rgb2gray(I); %to be processed, image is turned to gray

       %Detection
       tic
       [ index_P, ~, win(i) ] = use_cascade_val( cascade, f); 
       toc
    
       %Post processing
       h = unify_squares(index_P, 3, 0.2, 0.2, I);
      
       %show figure
       figure 
       imshow(h)
       pause
       imsave

    %% Inputs
    TP(i) = input('Veri positivi');
    FP(i) = input('Falsi positivi');
    FN(i) = input('Falsi negativi');
    TN(i) = win(i) - TP(i) - FP(i) - FN(i);
    %% Parameters Computation
    Accuracy(i) = (TP(i)+TN(i))/(TP(i)+TN(i)+FP(i)+FN(i)); 
    Precision(i) = TP(i)/(TP(i)+FP(i));
    Sens(i) = TP(i)/(TP(i)+FN(i));
    Spec(i) = TN(i)/(TN(i)+FP(i));
 end

%% Statistics
Acc_m = mean(Accuracy);
Pre_m = mean(Precision);
Sens_m = mean(Sens);
Spec_m = mean(Spec);
TP_m = mean(TP);
FP_m = mean(FP);
TN_m = mean(TN);
FN_m = mean(FN);

Acc_std = std(Accuracy);
Pre_std = std(Precision);
Sens_std = std(Sens);
Spec_std = std(Spec);
TP_std = std(TP);
FP_std = std(FP);
TN_std = std(TN);
FN_std = std(FN);

win_m = mean(win);
win_std = std(win);