function [ images ] = random_load( directory, numImg )
%% RANDOM_LOAD function
% This function loads 'numImg' random images from the directory.
% 
% INPUT: 'directory' : string with the directory name [string];
% 'numImg': number of random images to selct; if omitted, the functions
% loads every image in the directory;
% 
% OUTPUT: 'images' : cell array, where every cell is an image; [1 x
% numImg].
% % % % % % % 

%% Initializations
% load the pictures' names into 'names' array
names = dir(directory);

% compute the total number of images in the directory 
% subtract 2, because the first two elements found this way are not
% relevant
totImg = size(names,1) - 2;

% omitt second parameter to load all the images
if ~exist('numImg','var')
    numImg = totImg;
end

% create an array of numImg random indexes
ind = randperm(totImg,numImg) + 2;

% initialize the cell array containing the images
images = cell(1,numImg);

%% Load loop
for k = 1:numImg
    i = ind(k);
    filename = strcat(directory, names(i).name);
    images{k} = imread(filename);
end

end

