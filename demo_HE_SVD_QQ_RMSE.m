
clc;
clear all;
close all;

resize = 1;

reference = double(imresize(imread('/home/shivgahlout/Desktop/TCIA_data/SN_AM_dataset/GCTNI/data/2_also_ref_image_H&E.bmp'),resize)) / 255.0;
query = double(imresize(imread('/home/shivgahlout/Desktop/TCIA_data/SN_AM_dataset/GCTNI/data/24_H&E.bmp'),resize)) / 255.0;



flag = 1;


        
        clearvars param
        
        method = 'svd'; % chose among nmf or svd
        mode = 'transform'; % chose between transform or replace       
        param.squeezePercentile = 0.1; % required if method = svd
        param.quantityPercentile = 99.9; % match this percentile in both ref and query stains
        param.verbose = 0; % set to 1 to visualize various steps of the method.
        param.metric = 'RMSE'; % this can be set to RMSE or 
       
        
        [stainNormalizedQuery, phiHE, aQuery] = GCTI(query, reference, method, mode, param);
        
        
        
        [phiQuerySO, aQuerySO, phiReferenceSO, aReferenceSO] = stainColorCorrection(query,reference,method,'decompose',param);
        orig_rmse = calcQQPlotODRMSE_new(phiQuerySO,aQuerySO,phiReferenceSO,aReferenceSO,param);
        gcti_rmse = calcQQPlotODRMSE_new(phiHE,aQuery,phiReferenceSO,aReferenceSO,param);
        if flag
             fid = fopen('HE_SVD_QQ_RMSE.csv','w');
            fprintf(fid,['ImageName,',',Orig QQ_RMSE,',',,After GCTI QQ_RMSE,','\n']);
            fprintf(fid,',H,E,.,H,E,.\n');
            fprintf(['ImageName,',',Orig QQ_RMSE,',',,After GCTI QQ_RMSE,','\n']);
            fprintf(',H,E,.,H,E,.\n');
            flag=0;
        else
             fid = fopen('HE_SVD_QQ_RMSE.csv','a');
        end        
        fprintf(fid,'%f, %f, %f, %f, %f, %f\n',orig_rmse,gcti_rmse);        
        fprintf('%f, %f, %f, %f, %f, %f\n',orig_rmse,gcti_rmse);       
        fclose(fid);
        
        
        
              

