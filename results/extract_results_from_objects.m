%%
netname = 'unet';
N = 2;
folder = [netname num2str(N) '_result'];
netname = [netname num2str(N) '_256_'];
maxepoch = '160';

vis = 0;
%% Build the variables

lr = [0.0001 0.0005 0.001];
bsz = [2 8 12];

for i = 1:numel(lr)
    for j = 1:numel(bsz)
        %% Load the data iteration
        file_name = [netname num2str(lr(i))...
            '_'...
            num2str(bsz(j))...
            '_'...
            maxepoch ...
            '.mat'];
        disp(file_name);
        
        load([folder '/' file_name]);
        %%
        index = sub2ind(size(eye(3)),j,i);
        ConfusionMatrix{index} = test_metrics.ConfusionMatrix.Variables;
        NormalizedConfussionMatrix{index} = test_metrics.NormalizedConfusionMatrix;
        DataSetMetrics{index} = test_metrics.DataSetMetrics;
        ClassMetrics{index} = test_metrics.ClassMetrics;
        ImageMetrics{index} = test_metrics.ImageMetrics;
        TrainingAccuracy{index} = train_info.TrainingAccuracy;
        TrainingLoss{index} = train_info.TrainingLoss;
        ValidationAccuracy{index} = train_info.ValidationAccuracy;
        ValidationLoss{index} = train_info.ValidationLoss;
        BaseLearnRate{index} = train_info.BaseLearnRate;
        
        %% Clear vars
        clear net test_metrics train_info
    end
end
clear i j


%% Calculate TP, FN, FP, TN.
for LR = 1:3
    for BS = 1:3
        for cls = 1:N
            index = sub2ind(size(eye(3)),BS,LR);
            TP(LR,BS,cls) = ConfusionMatrix{index}(cls,cls);
            FN(LR,BS,cls) = sum(ConfusionMatrix{index}(cls,:)) - TP(LR,BS,cls);
            FP(LR,BS,cls) = sum(ConfusionMatrix{index}(:,cls)) - TP(LR,BS,cls);
            TN(LR,BS,cls) = sum(sum(ConfusionMatrix{index})) - TP(LR,BS,cls) - FP(LR,BS,cls) - FN(LR,BS,cls);
            
        end
    end
end


for LR = 1:numel(lr)
    for BS = 1:numel(bsz)
        for cls = 1:N
            index = sub2ind(size(eye(3)),BS,LR);
            acc(index,cls)=  (TN(LR,BS,cls) + TP(LR,BS,cls))/(TN(LR,BS,cls)+TP(LR,BS,cls)+FN(LR,BS,cls)+FP(LR,BS,cls));
            sens(index,cls) = TP(LR,BS,cls)/(TP(LR,BS,cls)+FN(LR,BS,cls)); % TPR
            iou(index,cls) = TP(LR,BS,cls)/(TP(LR,BS,cls)+FN(LR,BS,cls) + FP(LR,BS,cls));
            spec(index,cls) = TN(LR,BS,cls)/(TN(LR,BS,cls) + FP(LR,BS,cls)); %% TNR = 1-FPR
            dice_(index,cls) = (2*TP(LR,BS,cls))/(2*TP(LR,BS,cls) + FP(LR,BS,cls) + FN(LR,BS,cls));
            prec(index,cls) = TP(LR,BS,cls)/(TP(LR,BS,cls)+FP(LR,BS,cls));
            gmean(index,cls) = sqrt(spec(index,cls)*sens(index,cls));
            F1(index,cls) = ((2)*prec(index,cls)*sens(index,cls))/((1)*prec(index,cls)+sens(index,cls));
            F05(index,cls) = ((1+0.25)*prec(index,cls)*sens(index,cls))/((0.25)*prec(index,cls)+sens(index,cls));
            F2(index,cls) = ((1+4)*prec(index,cls)*sens(index,cls))/((4)*prec(index,cls)+sens(index,cls));
            
        end
    end
end

for index = 1:9
    GlobalAccuracy(:,index) = ImageMetrics{index}.GlobalAccuracy;
    MeanAccuracy(:,index) = ImageMetrics{index}.MeanAccuracy;
    MeanIoU(:,index) = ImageMetrics{index}.MeanIoU;
    WeightedIoU(:,index) = ImageMetrics{index}.WeightedIoU;
    MeanBFScore(:,index) = ImageMetrics{index}.MeanBFScore;
end
%%
if(vis > 0)
    figure;
    temp = 0;
    plotting = dice_;
    for LR = 1:numel(lr)
        for BS = 1:numel(bsz)
            subplot(numel(lr),numel(bsz),sub2ind(size(eye(3)),BS,LR))
            for i = 1:N
                temp(i) = plotting(sub2ind(size(eye(3)),BS,LR),i);
            end
            h = heatmap(temp);
            h.ColorLimits = [ min(min(min(plotting)))  max(max(max(plotting)))];
            colormap hot
        end
    end
    clear temp plotting h LR BS
end