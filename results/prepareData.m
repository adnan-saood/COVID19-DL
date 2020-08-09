function [imds, pxds] = prepareData(n_classes)

train_folder = ['..\dataset\im\noBlur\256'];

%% imds
imds = imageDatastore(train_folder);

%% Load classes
if(n_classes == 2)
    n_classes = ["regular" "irregular"];
    label_folder = ['..\dataset\mask\binary\256'];
    labels  = [0   255];
elseif (n_classes == 4)
    n_classes = ["C0" "C1" "C2" "C3"];
    labels  = [0 85 170 255];
    label_folder = ['..\dataset\mask\multi\256'];
end

pxds = pixelLabelDatastore(label_folder,n_classes,labels);



end