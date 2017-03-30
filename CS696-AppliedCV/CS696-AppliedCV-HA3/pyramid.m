clear all
close all
clc;
A = imread('CS696-AppliedCV/CS696-AppliedCV-HA3/benten.jpg');
f=rgb2gray(A);

center=[120 70];
B_size=[31 31];
t = imcrop(f,[center(2)-floor(B_size(2)/2) center(1)-floor(B_size(1)/2) B_size(2)-1 B_size(1)-1]);

CF1=imresize(t,0.5);
%size(CF1)
CF2=imresize(t,1);
CF3=imresize(t,2);

%% SSD
% Initialization
t = double(CF1);
f = double(f);

% Complex template construction
tc = 2*t*1i-1;
fc = f.^2+f*1i;

tc = rot90(tc,2);
m = conv2(fc,conj(tc),'same');
S = real(m);

% Result display
figure(2),imshow(uint8(f),[])
[c,r]=find(S==max(S(:))); %center found
%or 
%[c,r] = ind2sub([size(S,1),size(S,2)],ind); %center found

[w,h] = size(t);
rectangle('Position',[r-round(h/2), c-round(w/2), h, w],'EdgeColor','g','LineWidth',2);

distance_ssd= sqrt((c-center(1))^2+(r-center(2))^2)

%% NCC
[RowSmall,ColSmall]=size(CF1);

figure(1),imshow(CF1),title('Template')

cc=normxcorr2(CF1,f);
figure(2),imshow(cc),title('Normalized Cross Correlation Matrix')
[RowCc,ColCc]=size(cc);

[max_cc,imax]=max(abs(cc(:)));
max_cc
[ypeak,xpeak]=ind2sub(size(cc),imax(1))

BestRow=ypeak-(RowSmall-1)
BestCol=xpeak-(ColSmall-1)

row_center_found= BestRow+floor(B_size(2)/2)
col_center_found= BestCol+floor(B_size(1)/2)

figure(3),imshow(f),title('Image and the found template')
rectangle('Position',[BestCol, BestRow, (ColSmall-1), (RowSmall-1)],'EdgeColor','g','LineWidth',2);

distance_NCC= sqrt((row_center_found-center(1))^2+(col_center_found-center(2))^2)

%% zero_mean
%make it zero-mean by removing the average:
A11=f-mean(f(:));
B1=CF1-mean(CF1(:));

image_double1=im2double(A11);
image_double2=im2double(B1);

figure;
filtered = imfilter(image_double1,image_double2,'corr');
imshow(filtered);
[c1,r1]=find(filtered==max(filtered(:)))
distance_NCC= sqrt((c1-center(1))^2+(r1-center(2))^2)