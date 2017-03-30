clear all
close all
clc;

Resized_factor=1;

%f = imread('CS696-AppliedCV/CS696-AppliedCV-HA3/benten.jpg');figure,imshow(f),title('Frame Image')
f = imread('CS696-AppliedCV/CS696-AppliedCV-HA3/image1.jpg');figure,imshow(f),title('Frame Image')
f=rgb2gray(f);
f = imresize(f,Resized_factor);

center=[70 50];
B_size=[31 31];
t = imcrop(f,[center(2)-floor(B_size(2)/2) center(1)-floor(B_size(1)/2) B_size(2)-1 B_size(1)-1]);
t = imresize(t,Resized_factor);
[w,h]=size(t);
figure(1),subplot(1,2,1),imshow(f),title(['template-' num2str(B_size(2)-1) 'x' num2str(B_size(1)-1) ' pixels' ] )
rectangle('Position',[center(2)-round(h/2), center(1)-round(w/2), h, w],'EdgeColor','g','LineWidth',2);

% Initialization
t = double(t);
f = double(f);

% Complex template construction
tc = 2*t*1i-1;
fc = f.^2+f*1i;

% SSD

% If t is a template of the block you're searching for, 
% the minimum SSD match is equivalent 
% to the maximum non-normalized correlation match,
% correlation=conv2(f,rot90(t,2),'same');
% [c,r]=find(correlation==max(correlation(:)));

tc = rot90(tc,2);
m = conv2(fc,conj(tc),'same');
S = real(m);

% Result display
subplot(1,2,2),imshow(uint8(f),[]),title('Image and the found template')
[c,r]=find(S==max(S(:))); %center found
distance= sqrt((c-center(1))^2+(r-center(2))^2)
%or 
%[c,r] = ind2sub([size(S,1),size(S,2)],ind); %center found
rectangle('Position',[r-round(h/2), c-round(w/2), h, w],'EdgeColor','b','LineWidth',2);
suptitle(['Resized-factor : ' num2str(Resized_factor) ' / Distance : ' num2str(distance)])

