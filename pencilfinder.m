%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CMPT 412 pencilfinder.m
% Ivy Tse
% Feb 1, 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code Citations 
%
% Title: uigetfile
% Author: Matlab
% Date: 2015
% Availability: http://www.mathworks.com/help/matlab/ref/uigetfile.html
%
% Title: Correcting Nonuniform Illumination
% Author:Matlab 
% Date: 2015
% Availability: http://www.mathworks.com/help/images/examples/correcting-
%   nonuniform-illumination.html
%
% Title: regionprops
% Author:Matlab
% Date: 2015
% Availability: Available: http://www.mathworks.com/help/images/ref/
%   regionprops.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Uncomment the images below to find the pencils in each image

imagefile = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'mytitle',...
          'C:\Work\setpos1.png');

image = imread(imagefile);

%image=imread('CrossedPencilsA.jpg'); %read the image
%image=imread('OnePencilA.jpg');
%image=imread('Red_Green_Pencils.jpg');
%image=imread('SixCrossed.jpg');
%image=imread('Touching.jpg');
%image=imread('Three-on-Carpet.jpg');
figure, imshow(image);

greyscale=(double(image(:,:,1))+double(image(:,:,2))+double(image(:,:,3)))/(3*255);
%figure, imshow(greyscale), title('Greyscale'); 

%erode and dilate greyscale using a diamond mask
background = imopen(greyscale,strel('diamond',10));
greyscale2 = greyscale - background; %remove the background from greyscale
%figure, imshow(greyscale2), title('Removed Background');

%adjust greyscale contrast so that the pencils are more white than 
%than the background 
greyscale3 = imadjust(greyscale2, [0.1 0.2]);
%figure, imshow(greyscale3), title('Increased Contrast');

%convert the grayscale image to black and white with Otsu's method using
%the greythresh function
level = graythresh(greyscale3);
BW = im2bw(greyscale3,level);

%remove background noise using bwareaopen
BW = bwareaopen(BW, 50);
%figure, imshow(BW), title('Threshold Image');

BWlabel = bwlabel(BW); %label connected objects
pencils = regionprops(BWlabel,'centroid'); %find center of each pencil
centroids = cat(1, pencils.Centroid); %concatenate the center coordinates
figure, imshow(BW); hold on;
plot(centroids(:,1),centroids(:,2),'go', 'MarkerFaceColor', 'g','MarkerSize', 10)
disp('Pencil Center Coordinates: ')
disp(centroids)

