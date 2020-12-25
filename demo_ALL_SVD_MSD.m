
clc;
clear all;
close all;

resize = 1;


reference=double(imresize(imread('./data/ref_ALL.bmp'), resize))/255.0;
query = double(imresize(imread('./data/25_ALL_5.bmp'),resize)) / 255.0;


ref_mask_1 = imresize(imread('./data/ref_ALL_background_mask.bmp'),resize);
ref_mask_2 = imresize(imread('./data/ref_ALL_nucleus_mask.bmp'),resize);


flag = 1;

 
      

clearvars param

method = 'svd'; 
mode = 'transform'; % chose between transform or replace       
param.quantityPercentile = 99.9; % match this percentile in both ref and query stains
param.verbose = 0; % set to 1 to visualize various steps of the method.
param.squeezePercentile = 0.1; 


[stainNormalizedQuery, phiHE, aQuery,query,query2,ref1] = GCTI(query, reference, method, mode, param);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculate MSD Metric ########################       
param.que_mask = double(imresize(imread('./data/25_ALL_5_nucleus_mask.bmp'),resize));
param.ref_mask = ref_mask_2;
orig_msd=RMSE(query,reference,param);
final_msd=RMSE(stainNormalizedQuery,reference,param);
if flag
    fid = fopen('ALL_SVD_MSD.csv','w');
    fprintf(fid,['ImageName',',Orig MSD',',After GCTI MSD','\n']);
    fprintf(['ImageName',',Orig MSD',',After GCTI MSD','\n']);
    flag=0;
else
    fid = fopen('ALL_SVD_MSD.csv','a');
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




