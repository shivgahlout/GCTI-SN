 
function [queryNorm, phiQuery, aQuery,query,query2,ref1] = GCTI(query, reference, method, mode, param)
%%%%%%%%%%%%%%%% GCTI %%%%%%%%%%%%%%
% Implements the 3 step method proposed in the paper
%===================  INPUT ===================
% query : RGB query image
% reference : RGB reference Image
% method : Matrix factorization used for deconvolution -  
%           'svd' 
% mode : The stain vector transformation strategy used -
%        can be 'transform' or 'replace'
% param : miscelleneaous object having the following properties
      % 1. squeezePercentile :  this property should contain
      %        The robust extreme angles to determine wedge as defined by
      %        Macenko et al.
      % 2. verbose : if true, the program will print images from
      %              intermediate stages of stain normalization
%===================  OUTPUT ===================
% queryNorm : stain normalized Query image
% phiQuery : stain vectors of the normalized Query image
% aQuery : concentration matrix of the normalized Query image
%===============================================


    % process image through illumination correction module       
    [query,query2,ref1] = illuminationCorrection(query, reference);      
       %return;
    % process image through stain color correction module
    [phiQuery, aQuery, phiReference, aReference] = stainColorCorrection(query,reference,method,mode,param);       
    
    % process image through stain quantity correction module
    aQuery = stainQuantityCorrection(aReference,aQuery,param.quantityPercentile);
    
    
    queryNorm = od2rgb(reshape((phiQuery * aQuery)', size(query)));
    
          
    if param.verbose
        displayComponents(phiQuery,aQuery,phiReference,aReference,size(query),size(reference)); 
        suptitle('After Quantity Correction');
    end   
end







