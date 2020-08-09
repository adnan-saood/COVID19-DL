%% Nii file to Png image list. 
nii = niftiread('tr_mask.nii');
acc = zeros(512);
for i = 1:size(nii,3)
   img = nii(:,:,i);
   img  = img * 85;
   acc = acc + img;
end