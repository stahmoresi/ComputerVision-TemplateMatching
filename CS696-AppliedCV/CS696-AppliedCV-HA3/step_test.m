clc;
clear;
%Read an Image A(Template)
A = imread('CS696-AppliedCV/CS696-AppliedCV-HA3/benten.jpg');
A=rgb2gray(A);

%Read the Target Image
B = imread('CS696-AppliedCV/CS696-AppliedCV-HA3/watch.jpg');

B = imcrop(A,[110 175 226 102]);

LOC = step(vision.TemplateMatcher,A(:,:,1),B(:,:,1))