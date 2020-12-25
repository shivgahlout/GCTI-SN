
clc;
clear all;
close all;

resize = 1;



reference = double(imresize(imread('./data/5_also_ref_image_MM.bmp'),resize)) / 255.0;
ref_mask_1 = imresize(imread('./data/5_also_ref_image_MM_background_mask.bmp'),resize);
ref_mask_2 = imresize(imread('./data/5_also_ref_image_MM_nucleus_mask.bmp'),resize);

query = double(imresize(imread('./data/15_MM.bmp'),resize)) / 255.0;


flag = 1;


        

        
        clearvars param
        
        method = 'svd'; 
        mode = 'transform'; % chose between transform or replace       
        param.squeezePercentile = 0.1; % required if method = svd
        param.quantityPercentile = 99.9; % match this percentile in both ref and query stains
        param.verbose = 0; % set to 1 to visualize various steps of the method.
       
        
        [stainNormalizedQuery, phiHE, aQuery] = GCTI(query, reference, method, mode, param);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculate MSD Metric ########################       
        param.que_mask = double(imresize(imread('./data/15_MM_nucleus_mask.bmp'),resize));
        param.ref_mask = ref_mask_2;
        orig_msd=RMSE(query,reference,param);
        final_msd=RMSE(stainNormalizedQuery,reference,param);        
        if flag
            fid = fopen('MM_SVD_MSD.csv','w');
            fprintf(fid,['ImageName',',Orig MSD',',After GCTI MSD','\n']);
            fprintf(['ImageName',',Orig MSD',',After GCTI MSD','\n']);
            flag=0;
        else
            fid = fopen('MM_SVD_MSD.csv','a');
        end   
        fprintf(fid,'%f, %f\n',orig_msd,final_msd);        
        fprintf('%f, %f\n',orig_msd,final_msd);
        fclose(fid);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             
       
        figure;
        imshow([query stainNormalizedQuery reference]);
        title('1. Query, 2. Normalized Query, 3. Reference');
        



