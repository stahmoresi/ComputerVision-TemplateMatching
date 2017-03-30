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
[w,h]=size(B);

figure(1),subplot(1,3,1),imshow(A1),title(['template-' num2str(B_size(2)-1) 'x' num2str(B_size(1)-1) ' pixels' ] )
rectangle('Position',[center(2)-round(h/2), center(1)-round(w/2), h, w],'EdgeColor','g','LineWidth',2);


cc=normxcorr2(B,A1);
subplot(1,3,2),imshow(cc),title('Normalized Cross Correlation Matrix')
[RowCc,ColCc]=size(cc);

[max_cc,imax]=max(abs(cc(:)));
max_cc
[ypeak,xpeak]=ind2sub(size(cc),imax(1))

BestRow=ypeak-(w-1)
BestCol=xpeak-(h-1)

row_center_found= BestRow+floor(B_size(2)/2)
col_center_found= BestCol+floor(B_size(1)/2)

distance= sqrt((row_center_found-center(1))^2+(col_center_found-center(2))^2)

subplot(1,3,3),imshow(A1),title('Image and the found template')
rectangle('Position',[BestCol, BestRow, (h-1), (w-1)],'EdgeColor','b','LineWidth',2);
suptitle(['Resized-factor : ' num2str(Resized_factor) ' / Distance : ' num2str(distance)])

