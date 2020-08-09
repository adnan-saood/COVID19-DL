function out = testUNET(net, imds, pxds)
%% Testing
[imdsTrain,imdsVal,imdsTest,pxdsTrain,pxdsVal,pxdsTest] = partitionData(imds,pxds);


pxdsResults = semanticseg(imdsTest,net, ...
    'MiniBatchSize',4, ...
    'WriteLocation',tempdir, ...
    'Verbose',true);

test_metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTest,'Verbose',false);

out = test_metrics;
end