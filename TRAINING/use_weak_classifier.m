function [ class ] = use_weak_classifier( stump, XX, dim )
%% USE_WEAK_CLASSIFIER function
%   This function runs the weak classifier on a given image (integral
%   image).
% 
%   INPUT: 'stump': the weak classifier obtained from adaboost [10 x 1];
%   'XX': the integral image we want to evaluate [any dimension];
%   'dim' : the dimension of the image.
% 
%   OUTPUT: 'class' : our classification: '1' = face, '-1' = non face.
% % % % % % %

%% modify indexes according to dimension
if dim > 24
    e = floor((dim + 1)/24);
    i = 2 + floor(e*(stump(2) - 2));
    j = 2 + floor(e*(stump(3) - 2));
    h = floor(stump(4)*e);
    w = floor(stump(5)*e);
else 
    i = stump(2); j = stump(3); h = stump(4); w = stump(5);
end

% extract the parameters from the stump
f_type = stump(1);
t = stump(6);T = stump(7);
a = stump(4)*stump(5);

%% Feature Computation
%
switch f_type
    case 1
        
        S1 = XX(i+h-1,j+w-1) + XX (i-1,j-1) - XX(i-1,j+w-1) - XX(i+h-1,j-1);
        S2 = XX(i+h-1,j+2*w-1) +  XX(i-1,j+w-1) - XX(i-1,j+2*w-1) - XX(i+h-1,j+w-1);
        value = (S1 - S2)*((2*a)/(2*w*h));
    case 2
        S1 = XX(i+h-1,j+w-1) + XX (i-1,j-1) - XX(i-1,j+w-1) - XX(i+h-1,j-1);
        S2 = XX(i+h-1,j+2*w-1) +  XX(i-1,j+w-1) - XX(i-1,j+2*w-1) - XX(i+h-1,j+w-1);
        S3 = XX(i+h-1,j+3*w-1) +  XX(i-1,j+2*w-1) - XX(i-1,j+3*w-1) - XX(i+h-1,j+2*w-1) ;
        value = (S1 - S2 + S3)*((3*a)/(3*w*h));
    case 3
        S1 = XX(i+h-1,j+w-1) + XX (i-1,j-1) - XX(i-1,j+w-1) - XX(i+h-1,j-1);
        S2 = XX(i+2*h-1,j+w-1) +  XX(i+h-1,j-1) - XX(i+h-1,j+w-1) - XX(i+2*h-1,j-1) ;
        value = (S1 - S2)*((2*a)/(2*w*h));
    case 4
        S1 = XX(i+h-1,j+w-1) + XX (i-1,j-1) - XX(i-1,j+w-1) - XX(i+h-1,j-1);
        S2 = XX(i+2*h-1,j+w-1) +  XX(i+h-1,j-1) - XX(i+h-1,j+w-1) - XX(i+2*h-1,j-1) ;
        S3 = XX(i+3*h-1,j+w-1) +  XX(i+2*h-1,j-1) - XX(i+2*h-1,j+w-1) - XX(i+3*h-1,j-1) ;
        value = (S1 - S2 + S3)*((3*a)/(3*w*h));
end
% 
%% Classification
% 
if value*T > T*t
    class = 1;
else
    class = -1;
end

end

