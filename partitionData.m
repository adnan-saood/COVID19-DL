function [imdsTrain,imdsVal, imdsTest, pxdsTrain,pxdsVal, pxdsTest] = partitionData(imds,pxds)
% Partition CamVid data by randomly selecting 60% of the data for training. The
% rest is used for testing.

rng(0);
numFiles = numel(imds.Files);
shuffledIndices = randperm(numFiles);

% Use 72% of the images for training.
N_Train = round(0.72 * numFiles);
N_Val = round(0.1 * numFiles);
trainingIdx = shuffledIndices(1:N_Train);

% Use the rest for testing and validation
valIdx = shuffledIndices(N_Train+1:N_Train+N_Val);
testIdx = shuffledIndices(N_Train+N_Val+1:end);

% Create image datastores for training and test.
trainingImages = imds.Files(trainingIdx);
valImages = imds.Files(valIdx);
testImages = imds.Files(testIdx);
imdsTrain = imageDatastore(trainingImages);
imdsVal = imageDatastore(valImages);
imdsTest = imageDatastore(testImages);

% Extract class and label IDs info.
classes = pxds.ClassNames;
if(numel(pxds.ClassNames) == 2)
    labelIDs = [0 255];
elseif(numel(pxds.ClassNames) == 4)
    labelIDs = [0 85 170 255];
end

% Create pixel label datastores for training and test.
trainingLabels = pxds.Files(trainingIdx);
valLabels = pxds.Files(valIdx);
testLabels = pxds.Files(testIdx);
pxdsTrain = pixelLabelDatastore(trainingLabels, classes, labelIDs);
pxdsVal = pixelLabelDatastore(valLabels, classes, labelIDs);
pxdsTest = pixelLabelDatastore(testLabels, classes, labelIDs);
end