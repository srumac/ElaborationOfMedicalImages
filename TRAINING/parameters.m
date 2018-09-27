function [ index ] = parameters()
%% PARAMETERS function
%   This function creates a matrix with the indexes corresponding to each
%   evaluated feature. 
% 
%   INPUT: none.
% 
%   OUTPUT: 'index' : [141600 x 5] matrix. The first element of the indexes matrix is the
%   feature type (1). The other four are the indexes (2, 3, 4, 5).
% % % % % % %

%% Initializations

% the number of features depends on the size of the images (24x24)
index = zeros(141600,5);

% loop iterator (k)
k = 1;

%% First feature type
for i = 2:25
    for j = 2:24
        for h = 1:26-i
            for w = 1:floor((26-j)*0.5)
                index(k,:) = [1,i,j,h,w];
                k = k + 1;
            end
        end
    end
end 
%% Second feature type
for i = 2:25
    for j = 2:23
        for h = 1:26-i
            for w = 1:floor((26-j)/3)
                index(k,:) = [2,i,j,h,w];
                k = k + 1;
            end
        end
    end
end

%% Third feature type
for i = 2:24
    for j = 2:25
        for h = 1:floor((26-i)*0.5)
            for w = 1:26-j
                index(k,:) = [3,i,j,h,w];
                k = k + 1;
            end
        end       
    end
end

%% Fourth feature type
for i = 2:23
    for j = 2:25
        for h = 1:floor((26-i)/3)
            for w = 1:26-j
                index(k,:) = [4,i,j,h,w];
                k = k + 1;
            end
        end
    end
end

end

