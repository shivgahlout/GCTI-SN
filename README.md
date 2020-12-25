--------------------------------------------------------------------------------------
## GCTI-SN

Copyright (c) 2020, 
SBILab
IIIT-Delhi
--------------------------------------------------------------------------------------

### Code for our paper ["GCTI-SN: Geometry-inspired chemical and tissue invariant stain normalization of microscopic medical images."](https://www.sciencedirect.com/science/article/abs/pii/S1361841520301523?via%3Dihub)

### Dataset for this paper can be found [here](https://wiki.cancerimagingarchive.net/display/Public/SN-AM+Dataset%3A+White+Blood+cancer+dataset+of+B-ALL+and+MM+for+stain+normalization.)

### If you are using this code please cite the following papers: 
[1] Anubha Gupta, Rahul Duggal, Shiv Gehlot, Ritu Gupta, Anvit Mangal, Lalit Kumar, Nisarg Thakkar, and Devprakash Satpathy, "GCTI-SN: Geometry-Inspired Chemical and Tissue Invariant Stain Normalization of Microscopic Medical Images," Medical Image Analysis, Volume 65, 101788, 2020.
[2] A method for normalizing histology slides for quantitative analysis, M Macenko, M Niethammer, JS Marron, D Borland, JT Woosley, G Xiaojun, C Schmitt, NE Thomas, IEEE ISBI, 2009. dx.doi.org/10.1109/ISBI.2009.5193250 

### Demo
1. Run demo.m. It takes a reference image and a query image.
2. Results on ALL image:
<img src = "/data/ALL_results/ALL_query_normalized_reference.png" width ="1000"> 
3. Results on MM image:
<img src = "/data/MM_results/MM_normalized.png" width ="1000"> 
4. Results on H&E image:
<img src = "/data/H&E_results/HE_query_norm_ref.png" width ="1000"> 

### Step-wise results can also be visualized. For H&E image:

<img src = "/data/H&E_results/HE_illumination_cor.png" width ="500"> 
 
<img src = "/data/H&E_results/HE_basis_rep.png" width ="500"> 

<img src = "/data/H&E_results/HE_quant_cor.png" width ="500"> 

