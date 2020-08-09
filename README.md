# COVID-19 Semantic Segmentation.
## Background
Currently, there is an urgent need for efficient tools to assess in the diagnosis of COVID-19 patients. In this paper, we present feasible solutions for detecting and labeling infected tissues on CT lung images of such patients. Two structurally-different deep learning techniques, SegNet and UNET, are investigated for semantically segmenting infected tissue regions in CT lung images. 
## Methods 
We propose to use two known deep learning networks, SegNet and UNET, for image tissue classification.  SegNet is characterized as as scene segmentation network  and UNet as a medical segmentation tool.  Both networks were exploited as binary segmentors to discriminate between infected and healthy lung tissue, and as multi-class segmentors to learn the infection type on the lung. Each network is trained using 72 data images, validated on 10 images and tested against the left 18 images. Several statistical scores are calculated for the results and tabulated accordingly. 
## Results 
The results show the superior ability of SegNet in classifying infected/non-infected tissues compared to the other methods (with 0.95 mean accuracy), while the UNET shows better results as a multi-class segmentor (with  0.91 mean accuracy).
## Conclusion 
Semantically segmenting CT scan images of COVID-19 patients is a crucial goal because it would not only assist in disease diagnosis , but also help in quantifying the severity of the disease ,and hence, prioritize the population treatment accordingly. We propose computer-based techniques that prove to be reliable as detectors for infected tissue in lung CT scans. The availability of such a method in today's pandemic would help automate, prioritize, fasten, and broaden the treatment of COVID-19 patients globally. 

## SegNET

SegNet is a Deep Neural Network originally designed to model scene segmentors such as road images segmentation. This task requires the network to converge using highly imbalanced datasets since large areas of road images consist of classes as road, sidewalk, and sky, ... etc.
The SegNet network is a DNN with an encoder-decoder depth of three. The encoder layers are
identical to the convolutional layers of the VGG16 network. The decoder constructs the segmentation mask by utilizing pooling indices from the max-pooling of the corresponding encoder. The creators removed the fully connected layers to reduce complexity.
## UNET

The architecture of this network includes two main parts: contractive and expansive. The contracting path consists of several patches of convolutions with filters of size $3\times3$, and unity strides in both directions, followed by ReLU layers. This path extracts the key features of the input and results a feature vector of a specific length.
The second path pulls information from the contractive path via copying and cropping, and from the feature vector via up-convolutions, and generates, by a successive operation, an output segmentation map.
The key component of this architecture is the operation linking the first path with the second one, it allows the network to attain highly accurate information from the contractive path to help generate the segmentation mask as close as possible to the intended output.