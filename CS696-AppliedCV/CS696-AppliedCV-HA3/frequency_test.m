clc;
clear;
%Read an Image A(Template)
A = imread('CS696-AppliedCV/CS696-AppliedCV-HA3/benten.jpg');

%Read the Target Image
B = imread('CS696-AppliedCV/CS696-AppliedCV-HA3/watch.jpg');

figure,subplot(2,1,1);imagesc(A);title('Image 1');axis image
subplot(2,1,2);imagesc(B);title('Image 2');axis image

%Crop a part from the image matrix B
B = imcrop(B,[58.5 49.5 226 102]);
figure,imagesc(B);title('sub Image - Image 2');axis image

%Pad the image matrix B with zeros
B1 = zeros([size(A,1),size(A,2)]);
B1(1:size(B,1),1:size(B,2))=B(:,:,1);

%Apply Fourier Transform
Signal1 = fftshift(fft2(A(:,:,1)));
Signal2 = fftshift(fft2(B1));

%Mulitply Signal1 with the conjugate of Signal2
R = Signal1 .*conj(Signal2);

%Normalize the result
Ph = R./abs(R);



%Apply inverse fourier transform
IFT = ifft2(fftshift(Ph));

figure,imagesc((abs((IFT))));colormap(gray);
%Find the maximum value
maxpt = max(real(IFT(:)));

%Find the pixel position of the maximum value
[x,y]= find(real(IFT)==maxpt);

figure,subplot(1,2,1);imagesc(A(x:x+size(B,1),y:y+size(B,2),:));axis image
subplot(1,2,2);imagesc(B);axis image