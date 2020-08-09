%% Experiment

imSize = '64';
n_classes = 4;

net_name = 'segnet';

result_folder = [net_name '_result'];

system(join(['mkdir ' result_folder]));

InitialLearnRate= [0.0001    0.001    0.003   0.0051];
MiniBatchSize= [2 6 12];
MaxEpochs= 1;


[imds, pxds] = prepareData(imSize, n_classes);

%%
for iter_InitialLearnRate = InitialLearnRate
    for iter_MiniBatchSize = MiniBatchSize
        %% Train
        [net,train_info] = trainSegNET(iter_InitialLearnRate, iter_MiniBatchSize, MaxEpochs,  n_classes, imSize, imds, pxds);
        
        %% Test
        test_metrics = testSegNET(net, imds, pxds);        
        experiment_metrics(iter_InitialLearnRate,iter_MiniBatchSize) = test_metrics;

        save([result_folder '/'...
            net_name...
            num2str(n_classes)...
            '_' imSize...
            '_' num2str(iter_InitialLearnRate)...
            '_' num2str(iter_MiniBatchSize)...
            '_' num2str(MaxEpochs)...
            '.mat'],'net','train_info', 'test_metrics');
        
        fprintf("SegNET | MiniBatch = %d  || ILR = %d \n", iter_MiniBatchSize, iter_InitialLearnRate );
    end
end
