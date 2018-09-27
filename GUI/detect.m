function [mov_out, n] = detect(Mov, cascade)
% This function proceed with the detection of faces using the trained
% cascade. 
%INPUTS: - mov, the frames of the video to process
%             - cascade, the result of the training able to proceed with
%               face detection
%OUTPUTS: - mov_out, the new frames showing the original video + the green
%                  squares pointing out the face detection
%                 - n, the number of positives found by the cascade

mov_out = Mov;

%for every frame, detect faces
for i=1:length(Mov) 
     h=Mov(i).cdata; %Save the image to process
     f=rgb2gray(h); %Change image to grayscale

     %Detect faces using cascade
     [ index_P, n ] = use_cascade( cascade, f );

     %Post process the image - commented if post processing is not necessary
     %mov_out(i).cdata = unify_squares(index_P, 2, 0.2, 0.2, h);
      
     %draw squares
     mov_out(i).cdata = squares(index_P, h, 0);
end
end