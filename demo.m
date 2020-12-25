
clc;
clear all;
close all;

resize = 1;


reference=double(imresize(imread('./data/2_also_ref_image_H&E.bmp'), resize))/255.0;
query = double(imresize(imread('./data/24_H&E.bmp'),resize)) / 255.0;

clearvars param

method = 'svd'; 
mode = 'transform'; % chose between transform or replace       
param.squeezePercentile = 0.1; 
param.quantityPercentile = 99.9; % match this percentile in both ref and query stains
param.verbose = 1; % set to 1 to visualize various steps of the method.       

[stainNormalizedQuery, phiHE, aQuery] = GCTI(query, reference, method, mode, param);

figure;
imshow([query stainNormalizedQuery reference]);
title('1. Query, 2. Normalized Query, 3. Reference');

