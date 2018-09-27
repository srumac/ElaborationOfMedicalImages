%%Initializations
TP_std = zeros(1, 20);
TN_std = zeros(1, 20);
FP_std = zeros(1, 20);
FN_std = zeros(1, 20);
Accuracy_std = zeros(1, 20);
Precision_std = zeros(1, 20);
Sens_std= zeros(1, 20);
Spec_std = zeros(1, 20);

for i =1:20
    %% Inputs
    TP_std(i) = input('Veri positivi');
    FP_std(i) = input('Falsi positivi');
    FN_std(i) = input('Falsi negativi');
    TN_std(i) = win(i)-TP_std(i)-FP_std(i)-FN_std(i);
    %% Parameters Computation
    Accuracy_std(i) = (TP_std(i)+TN_std(i))/(TP_std(i)+TN_std(i)+FP_std(i)+FN_std(i));
    Precision_std(i) = TP_std(i)/(TP_std(i)+FP_std(i));
    Sens_std(i) = TP_std(i)/(TP_std(i)+FN_std(i));
    Spec_std(i) = TN_std(i)/(TN_std(i)+FP_std(i));
end