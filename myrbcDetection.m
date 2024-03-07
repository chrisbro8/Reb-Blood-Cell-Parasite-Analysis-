function [outputImage, numRBCs]=myrbcDetection(imagePath)
    % Read the grayscale image
    originalImage = imagePath;
    grayImage = rgb2gray(originalImage);
    % Apply contrast enhancement or other preprocessing if needed 
    %imadjust adjust the intensity values and contrast by streching or
    %compressing the Intensity
    enhancedImage = adapthisteq(grayImage);
    % Thresholding to binarize the image
    threshold = graythresh(enhancedImage);
    binaryImage = imbinarize(enhancedImage, threshold);
    % Morphological filtering to remove noise
    se = strel('disk', 1); % Adjust the structuring element based on image characteristics
    
     filteredImage = imopen(binaryImage, se);%dialation follwed by erosion
    figure,imshow(filteredImage);
    % Label connected components and obtain region properties
    [labeledImage, numRBCs] = bwlabel(filteredImage);
    regionProps = regionprops(labeledImage, 'Centroid');
    % Create a marked image with centroids
    markedImage = originalImage;
    for i = 1:numRBCs
        center = round(regionProps(i).Centroid);
        markedImage = insertMarker(markedImage, center, 'color', 'red', 'size', 3);
    end
    % Return the total number of RBCs
    fprintf('Total number of RBCs: %d\n', numRBCs);
    outputImage=markedImage;
    
