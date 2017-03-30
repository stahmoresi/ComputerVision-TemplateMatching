function [blurredImage] = GaussianBlur(image, kernelSize, sigma)
% 2-dimensional Gaussian Blur
% applies a Gaussian Blur filter mask to a grayscale image
% [blurredImage] = GaussianBlur(image, kernelSize, sigma)

% Get dimensions of image
[xi,yi] = size(image);

% Set output to image (for now)
blurredImage = image;

% Find the offset point (need this to create the meshgrid)
offset = floor(kernelSize/2);

[x,y] = meshgrid(-kernelSize+offset+1:1:kernelSize-offset-1,  -kernelSize+offset+1:1:kernelSize-offset-1); % coordinates

% Kernel generation
kernel = 1/sqrt(2*pi*sigma^2);               
kernel = kernel*exp(-(x.^2+y.^2)/(2*sigma^2));

% normalize kernel
kernel = 1/sum(kernel(:))*kernel;

% Apply Gaussian Blur to Image
for n=(offset+1):(xi-offset)
    for m=(offset+1):(yi-offset)
        total=0;
        for i=1:kernelSize
            for j=1:kernelSize
                total=total+image(n+x(i,j),m+y(i,j))*kernel(i,j);
            end
        end
        blurredImage(n,m) = total;
    end
end
end