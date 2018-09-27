function [h] = unify_squares(index_P, num_sq, perc_dim, perc_ind, g)
%% Unify squares function
%This function post process the squares indexes, working on redundant face 
%detections. 
%
%INPUTS: 'index_P': square indexes
%'num_sq': Threshold on the number of subwindows to mean
%'perc_dim', 'perc_ind': percentage to apply to square dimension to compute
%dimension and distance thresholds 

%OUTPUT: 'h': image showing detection squares

indici = [1:length(index_P)];     % array containing subwindows positions in "index_P" array
new = {};                                % cell containing residual subwindows, after post processing                                 


% The mean (of dimensions and of position) is computed for every 'n' group of subwindows less distant than "soglia_indici" and
% with smaller dimension difference than "soglia_dim". 

%The following for cycle considers only new subwindows - with corresponding
%index in "indici" different from zero
for k=indici(indici~=0)
    %Initialization of sums of positions and dimension. The mean will be
    %computed dividing the sums by "n"
    sum_i = index_P{k}(1);
    sum_j = index_P{k}(2);
    sum_d = index_P{k}(3);
    n = 1;

        for l=indici(indici>k)
            %Thresholds on squares dimension and distance, expressed as
            %dimension percentage
            soglia_dim = perc_dim*(index_P{k}(3));
            soglia_indici =perc_ind*(index_P{k}(3));

            %Necessary condition in order to compute the mean: distance and
            %dimension difference must be smaller than resoective
            %thresholds
            if abs(index_P{k}(1)-index_P{l}(1))<soglia_indici && abs(index_P{k}(2)-index_P{l}(2))<soglia_indici && abs(index_P{k}(3)-index_P{l}(3))<soglia_dim
                n=n+1;
                sum_i = sum_i + index_P{l}(1);
                sum_j = sum_j + index_P{l}(2);
                sum_d = sum_d + index_P{l}(3);

                %Necessary condition in order to save meaned subwindows in
                %"new" cell: n > minimum number of squares to mean
                if n > num_sq
                    new{k}=[floor(sum_i/n) floor(sum_j/n) floor(sum_d/n)];
                end

                % Already considered windows' indexes are put to zero - the following iteration will not consider them 
                indici(indici==l)=0;
            end
    end
end

%Delete null elements from "new", obtain "newnew"
newnew = new(~cellfun('isempty', new));

%Draw resulting squares on the image
h = squares(newnew, g);

end
