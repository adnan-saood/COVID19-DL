function out = saveImages(net, imds, pxds)

[imdsTrain,imdsVal,imdsTest,pxdsTrain,pxdsVal,pxdsTest] = partitionData(imds,pxds);

for index = 1:numel(imdsTest.Files)
    imgTest = imdsTest.readimage(index);
    true_mask = pxdsTest.readimage(index);
    true_mask = (double(true_mask) - 1)*255;
    C = semanticseg(imgTest,net);
    B = (uint8(C)-1)*255;
    
    
    imwrite(imgTest,[result_folder 'im_test/test_' imdsTest.Files{index}(end-7:end)]);
    imwrite(B, [result_folder 'im_segnet' num2str(n_classes) 'out/segnet2_' imdsTest.Files{index}(end-7:end)]);
    imwrite(true_mask,[result_folder 'testlabels/test_' pxdsTest.Files{index}(end-14:end)]);
end

end