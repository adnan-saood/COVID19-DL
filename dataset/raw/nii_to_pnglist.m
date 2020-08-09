%% Nii file to Png image list. 
nii = niftiread('tr_mask.nii');
for i = 1:size(nii,3)
   img = nii(:,:,i);
   img  = uint8(img) * 85;
   order = num2str(i);
   if (i <10)
       order = ['00' order];
   elseif (i < 100 && i >= 10)
       order = ['0' order];
   else
   end
   imwrite(img, ['tr_mask_2\tr_mask_z' order '.png']);
   disp(['tr_mask_2\tr_mask_z' order '.png']);
end