function out = saveTestimages(net)

result_folder = 'results\samples\unet4\';
[imds, pxds] = prepareData(4);
[imdsTrain,imdsVal,imdsTest,pxdsTrain,pxdsVal,pxdsTest] = partitionData(imds,pxds);

for index = 1:numel(imdsTest.Files)
    imgTest = imdsTest.readimage(index);
    true_mask = pxdsTest.readimage(index);
    true_mask = (uint8(true_mask) - 1)*85;
    C = semanticseg(imgTest,net);
    B = (uint8(C)-1)*85;
    
    
    imwrite(imgTest,[result_folder num2str(index) 'test_' imdsTest.Files{index}(end-7:end)]);
    imwrite(B, [result_folder num2str(index) 'unet4_' imdsTest.Files{index}(end-7:end)]);
    imwrite(true_mask,[result_folder num2str(index) 'label_' pxdsTest.Files{index}(end-7:end)]);
end

end