function [ blocks, indexes ] = break_img( img,dim )
%% BREAK_IMG function
%   This function breaks an image of any dimension in subwindows of [dim x
%   dim] dimension; the subwindows are separated by a number of pixel
%   (delta) that is proportional to the window size. Delta is always close
%   to the 4% of the window dimension.
% 
%   INPUT: 'img' : the image [any dimension];
%   'dim' : the dimension of the subwindow we want to break the image into.
% 
%   OUTPUT: 'blocks' : the cell array containing all the [dim x dim]
%   subwindows;
%   'indexes' : the cell array containing the corresponding indexes [dim x
%   dim].
% 
% % % % % % %

%% Initializations

% needed for computation
dim = dim - 1;

% extract the dimension of 'img'
row_img = size(img,1); col_img = size(img,2);

% define the limits of the image
a = row_img - dim;
b = col_img - dim;

% compute delta (about 4% of the window dimension)
delta = dim/24; 

% compute the total number of subwindows and initialize the cell arrays
% according to it
sizeCells = length(1:delta:a)*length(1:delta:b);
blocks = cell(1,sizeCells); 
indexes = cell(1,sizeCells);

% initialize loop counter
k = 1; 
%% Main Loop
for i = 1:delta:a
    % delta could be a real number, use floor()
    ii = floor(i); 
    %
    for j = 1:delta:b
        %
        jj = floor(j);
        blocks{k} = img(ii:ii+dim , jj:jj+dim);
        indexes{k} = [ii, jj, dim];
        k = k + 1;
    end
end


end

