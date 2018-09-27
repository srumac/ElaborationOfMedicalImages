function [ II,devstan ] = int_image( images )
%% INT_IMAGE function
%   This function takes every image in the data set, substracts its mean
%   value and normalizes it using its standard deviation. In order to do so, the image
%   needs to be first converted to double or single (in our case).
%
%   INPUT: 'images': it can be a cell array containing the dataset, or a
%   single image [any dimension].
%
%   OUTPUT: 'II': cell array containing the integral image of the normalized
%   images, or the integral image of a single image. All normalized images
%   have zero mean and unit variance [dimension of 'images'].
%   'devstan' : an array containing the stantard deviation of the original
%   image.
% % % % % % % 

%%  Main

% extract the size of the dataset
sizeSet = size(images,2);

% if the input is a cell array
if iscell(images) == 1
    
    % initialize the cell array containing the integral images
    II = cell(1, sizeSet);
    %
    for i = 1:sizeSet
        
        % temp = current image
        temp = im2single(images{i});

        % subtract the mean value
        x = temp - mean2(temp);

        % normalize the image
        devstan = std(x(:));

        
        % compute the integral image and save it into the current cell
        II{i} = integralImage(x);
    end
    
% if the input is a single image, same process as above
else
    temp = im2single(images);
    x = temp - mean2(temp);
    devstan = std(x(:));
    x = x./devstan;
    II = integralImage(x);
end

end

