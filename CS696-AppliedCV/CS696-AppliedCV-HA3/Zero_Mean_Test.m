clear all
close all
clc;

Resized_factor=1;

%A = imread('CS696-AppliedCV/CS696-AppliedCV-HA3/benten.jpg');
A = imread('CS696-AppliedCV/CS696-AppliedCV-HA3/image1.jpg');
A1=rgb2gray(A);
A1 = imresize(A1,Resized_factor);

center=[70 50];
B_size=[11 11];
B = imcrop(A1,[center(2)-floor(B_size(2)/2) center(1)-floor(B_size(1)/2) B_size(2)-1 B_size(1)-1]);

B = imresize(B,Resized_factor);
[w,h] = size(B);

figure(1)
subplot(1,2,1), imshow(A1)
title(['template-' num2str(B_size(2)-1) 'x' num2str(B_size(1)-1) ' pixels' ] )
%figure(1),imshow(A1)

rectangle('Position',[center(2)-round(h/2), center(1)-round(w/2), h, w],'EdgeColor','g','LineWidth',2);

A11=A1-mean(A1(:));
% make it zero-mean by removing the average:
B1=B-mean(B(:));
%and unit variance by dividing by the standard deviation:
%B2=B1/std(B1(:));

image_double1=im2double(A11);
image_double2=im2double(B1);

%LOC = step(vision.TemplateMatcher,A1,B1)
%figure(2);
filtered = imfilter(image_double1,image_double2,'corr');
subplot(1,2,2),imshow(filtered);
title('found');
%imagesc(filtered)
max((filtered(:)))
[c,r]=find(filtered==max(filtered(:)))
distance= sqrt((c-center(1))^2+(r-center(2))^2)

%[w,h] = size(B);
rectangle('Position',[r-round(h/2), c-round(w/2), h, w],'EdgeColor','b','LineWidth',2);
suptitle(['Resized-factor : ' num2str(Resized_factor) ' / Distance : ' num2str(distance)])
