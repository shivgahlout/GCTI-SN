
clc;
clear all;
close all;

resize = 1;



reference = double(imresize(imread('./data/2_also_ref_image_H&E.bmp'),resize)) / 255.0;
query = double(imresize(imread('./data/24_H&E.bmp'),resize)) / 255.0;




flag = 1;



clearvars param

method = 'svd'; 
mode = 'transform'; % chose between transform or replace       
param.squeezePercentile = 0.1; % required if method = svd
param.quantityPercentile = 99.9; % match this percentile in both ref and query stains
param.verbose = 0; % set to 1 to visualize various steps of the method.
param.metric = 'RMSE'; % this can be set to RMSE or 


[stainNormalizedQuery, phiHE, aQuery] = GCTI(query, reference, method, mode, param);



[phiQuerySO, aQuerySO, phiReferenceSO, aReferenceSO] = stainColorCorrection(query,reference,method,'decompose',param);
[orig_p orig_ksstat] = calcODKstat_new(phiQuerySO,aQuerySO,phiReferenceSO,aReferenceSO,'',size(query),size(reference),param);
[gcti_p gcti_ksstat] = calcODKstat_new(phiHE,aQuery,phiReferenceSO,aReferenceSO,'',size(query),size(reference),param);
fid = fopen('KSSTAT.csv','a');
if flag
    fid = fopen('HE_SVD_KSSTAT.csv','w');
    fprintf(fid,['ImageName,',',Orig KSSTAT,',',,After GCTI KSSTAT,','\n']);
    fprintf(fid,',H,E,.,H,E,.\n');
    fprintf(['ImageName,',',Orig KSSTAT,',',,After GCTI KSSTAT,','\n']);
    fprintf(',H,E,.,H,E,.\n');
    flag=0;
else
    fid = fopen('HE_SVD_KSSTAT.csv','a');
end        
fprintf(fid,'%f, %f, %f, %f, %f, %f\n',orig_ksstat,gcti_ksstat);        
fprintf('%f, %f, %f, %f, %f, %f\n',orig_ksstat,gcti_ksstat);       
fclose(fid)
figure;
imshow([query stainNormalizedQuery reference]);
title('1. Query, 2. Normalized Query, 3. Reference');



