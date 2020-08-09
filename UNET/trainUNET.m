%% Train The UNET
function [net,train_info] = trainUNET(InitialLearnRate, MiniBatchSize, MaxEpochs,  n_classes, imSize, imds, pxds)
%% Dataset analysis

counts = countEachLabel(pxds);



%% Prepare Training and test data partitions
[imdsTrain,imdsVal,imdsTest,pxdsTrain,pxdsVal,pxdsTest] = partitionData(imds,pxds);



%% Network Creation

im_Size = [str2double(imSize) str2double(imSize) 1];
net_graph = unetLayers(im_Size,n_classes,'EncoderDepth',2);


%% Balance Classes Using Median Class Weighting

freq_pixels = counts.PixelCount ./ counts.ImagePixelCount;
W = median(freq_pixels) ./ freq_pixels;


%% Mod. the class weights

pxLayer = pixelClassificationLayer('Name','labels','Classes',counts.Name,'ClassWeights',W);
net_graph = removeLayers(net_graph,'Segmentation-Layer');
net_graph = addLayers(net_graph, pxLayer);
net_graph = connectLayers(net_graph,'Softmax-Layer','labels');

%%
pximdsVal = pixelLabelImageDatastore(imdsVal,pxdsVal);


%% Training Options

options = trainingOptions('adam', ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.95, ...
    'LearnRateDropPeriod',12,...
    'InitialLearnRate',InitialLearnRate, ...
    'L2Regularization',0.0001, ...
    'MaxEpochs',MaxEpochs, ...
    'MiniBatchSize',MiniBatchSize, ...
    'ValidationData',pximdsVal,...
    'ValidationFrequency', 10,...
    'Shuffle','every-epoch', ...
    'VerboseFrequency',100);

%% Data Augmentation
rng(0);
augmenter = imageDataAugmenter('RandYReflection',true,...
    'RandXShear', [-10 10], 'RandYShear', [-10 10]);

%% Config inputs to trainer
pximds = pixelLabelImageDatastore(imdsTrain,pxdsTrain, 'DataAugmentation',augmenter);
%% Train the fucktard

[net, train_info] = trainNetwork(pximds,net_graph,options);


end
%%
