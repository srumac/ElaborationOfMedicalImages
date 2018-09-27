function h = squares(newnew, g)
%% Squares function
%This function draw detection squares on processed image
%
%INPUTS; 'newnew': cell containing squares indexes
%'g': processed image
%
%OUTPUT: 'h': Processed image showing detection squares

h = g;

%for every index pair and square dimension, draw a square
for i=1:length(newnew)
A=newnew{i};
ii=A(1);
jj=A(2);
dim=A(3);

%square color is green
h(ii:ii+dim-1, jj, 2)=256; 
h(ii, jj:jj+dim-1, 2)=256;
h(ii:ii+dim-1, jj+dim-1, 2)=256;
h(ii+dim-1,jj:jj+dim-1, 2)=256;
h(ii:ii+dim-1, jj, 1)=0;
h(ii, jj:jj+dim-1, 1)=0;
h(ii:ii+dim-1, jj+dim-1, 1)=0;
h(ii+dim-1,jj:jj+dim-1, 1)=0;
h(ii:ii+dim-1, jj, 3)=0;
h(ii, jj:jj+dim-1, 3)=0;
h(ii:ii+dim-1, jj+dim-1, 3)=0;
h(ii+dim-1,jj:jj+dim-1, 3)=0;
end
end