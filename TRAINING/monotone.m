function y = monotone( x )
%% MONOTONE function
%   This function decides if the numbers in 'x' are a monotone function
%
%   INPUT: 'x': the series we want to evaluate [any dimension];
%
%   OUTPUT: 'y' : '0' if x is not strictly monotone; otherwise '1'
%
% % % % % % %

inc = all(diff(x)>0);
decr = all(diff(x)<0);
if inc == 0 && decr == 0
    y = 0;
else 
    y = 1;
end

end

