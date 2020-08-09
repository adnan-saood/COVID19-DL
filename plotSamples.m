function out = plotSamples(net, imds, pxds)

[imdsTrain,imdsVal,imdsTest,pxdsTrain,pxdsVal,pxdsTest] = partitionData(imds,pxds);

figure;
for index = 1:numel(imdsTest.Files)
    imgTest = imdsTest.readimage(index);
    true_mask = pxdsTest.readimage(index);
    true_mask = (double(true_mask) - 1)*85;
    
    C = semanticseg(imgTest,net);
    B = (uint8(C)-1)*85;
    subplot(numel(imdsTest.Files)/3,3,index);
    imagesc([true_mask B], [0 255])
    axis equal
end


end