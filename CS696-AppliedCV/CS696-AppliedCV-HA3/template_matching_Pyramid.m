%% Template Matching using Image Pyramids
% finds a template in ann image using 2 image pyramids. A Gaussian Blur kernel is applied
% after subsampling the search image and template.

clear all
close all
clc;
%% Image Load

% load images
I = imread('CS696-AppliedCV/CS696-AppliedCV-HA3/image1.jpg');
center=[40 60];
B_size=[11 11];
temp = imcrop(I,[center(2)-floor(B_size(2)/2) center(1)-floor(B_size(1)/2) B_size(2)-1 B_size(1)-1]);

g=rgb2gray(I);
gtemp=rgb2gray(temp);
[w,h] = size(gtemp);

figure(1)
subplot(1,2,1), imshow(g)
title(['template-' num2str(B_size(2)-1) 'x' num2str(B_size(1)-1) ' pixels' ] )
rectangle('Position',[center(2)-round(h/2), center(1)-round(w/2), h, w],'EdgeColor','g','LineWidth',2);

g=im2double(g);
gtemp=im2double(gtemp);

%% Subsample image

% First sub-sample
[x,y]=meshgrid(1:2:length(g), 1:2:length(g(:,1)));
gprime = g(y(:,1), x(1,:));
gprimeB = GaussianBlur(gprime, 3, 1);
gtemp2=gtemp;
[xg,yg] = size(gtemp2);
[xt,yt]=meshgrid(1:2:xg, 1:2:yg);
gprimet = gtemp2(xt(1,:), yt(:,1));
gprimetB = GaussianBlur(gprimet, 3, 1);
 
% 2nd sub-sample
[x,y]=meshgrid(1:2:length(gprimeB), 1:2:length(gprimeB(:,1)));
gprime2 = gprimeB(y(:,1), x(1,:));
gprimeB2 = GaussianBlur(gprime2, 3, 1);
[xg,yg] = size(gprimetB);
[xt,yt]=meshgrid(1:2:xg, 1:2:yg);
gprimet2 = gprimetB(xt(1,:), yt(:,1));
gprimetB3 = GaussianBlur(gprimet2, 3, 1);

%% Template Matching Algorithm

% searches the nth image pyramid first.
% When correlation to template is found determine a
% search area to the original search image using that
% information.
% now the search area with the lowest SAD score is known
% and the respective coordinates of the search image are known.
% Need to use these coordinates and provide a search area for the
% original image.
%%%

% Get dimensions
[gx,gy] = size(gprimeB2);
[dimx, dimy] = size(gprimetB3);

% Low threshold
low = 1e10;

coordinate_x=0;
coordinate_y=0;
for n=1:(gx-dimx)
    for m=1:(gy-dimy)   
        %Template Space
        bbb=gprimeB2(n:dimx+n-1,m:dimy+m-1);
        totb=abs(bbb-gprimetB3);
        tot=sum(totb(:));
        SAD(n,m) = tot;
       if (SAD(n,m) < low) % search space has lowest SAD score so far
           low = SAD(n,m);
           coordinate_x = n; % record center pixel x value on search space
           coordinate_y = m; % '                 ' y '                    '
       end
    end
end

% 2 Image pyramids = factor of 4:
% Apply margin of 100 pixels (should modularize this)

startx = coordinate_x*4-100;
endx = coordinate_x*4+100;
starty = coordinate_y*4-100;
endy = coordinate_y*4+100;

if min(startx) < 0
    startx = 1;
end

if min(starty) < 0
    starty = 1;
end

if max(endx) > length(g(1,:))
    endx = length(g(1,:));
end

if max(endy) > length(g(:,1))
    endy = length(g(:,1));
end

searchx = startx:1:endx;
searchy = starty:1:endy;
[dimx, dimy] = size(gtemp);

% Search Space < this should be the image pyramid space >
for n=1:length(searchx)
    for m=1:length(searchy)   
        %Template Space
        bbb=g(searchx(n):dimx+searchx(n)-1,searchy(m):dimy+searchy(m)-1);
        totb=abs(bbb-gtemp);
        tot=sum(totb(:));
        SAD(n,m) = tot;
       if (SAD(n,m) < low) % search space has lowest SAD score so far
           low = SAD(n,m);
           coordinate_x = searchx(n); % record center pixel x value on search space
           coordinate_y = searchy(m); % '                 ' y '                    '
       end
    end
end

% Get template dimensions
[dtempx, dtempy] = size(gtemp);

distance= sqrt((coordinate_x-center(1))^2+(coordinate_y-center(2))^2)

% Show original color image with the found template box
subplot(1,2,2), imshow(g),title('Image and the found template');
hold on;
rectangle('Position', [coordinate_y coordinate_x dtempy dtempx],'EdgeColor','b', 'LineWidth', 2);
suptitle(['Using Image Pyramids & Gaussian Blur kernel / Distance : ' num2str(distance)])