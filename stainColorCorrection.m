function [phiQueryCorrected aQueryCorrected phiRef aRef] = stainColorCorrection(query,reference,method,mode,param)
%%%%%%%%%%%%%%%% stainColorCorrection %%%%%%%%%%%%%%
%Jointly aligns and orients the query basis
%===================  INPUT ===================
% query : RGB query image
% reference : RGB reference Image
% method : Matrix factorization used for deconvolution -  
%          can be 'svd'
% mode : The stain vector transformation strategy used -
%        can be 'transform' or 'replace'
% param : miscelleneaous object having the properties defined in GCTI.m      
%===================  OUTPUT ===================
% phiQueryCorrected : corrected stain vectors for Query
% aQueryCorrected : corrected concentration matrix for query 
% phiRef : corrected stain vectors for reference
% aRef : corrected concentration matrix for reference 
%===============================================

    %determine stain color basis for ref and query  
        

        
   if strcmp(method,'svd')
        % method defined by Macenko et al.
        [phiRef, aRef] = getWedgeMacenko(reference,param.squeezePercentile);
        [phiQue, aQue] = getWedgeMacenko(query,param.squeezePercentile); 
    else 
        fprintf('chose correct method\n');
    end
       
    if param.verbose
        displayComponents(phiQue,aQue,phiRef,aRef,size(query),size(reference)); 
        suptitle('After Illumination Correction');
    end
    
    if strcmp(mode,'replace')
        phiQueryCorrected = phiRef;
        aQueryCorrected = aQue;
                
    elseif strcmp(mode,'transform')
         %match orientation of basis
        [aQue, phiQue] = matchAndAlignOrientation(phiQue,phiRef,aQue,aRef,size(query),size(reference),param.verbose);   
        
         %rotate and align basis
        [phiQueryCorrected, aQueryCorrected] = alignWedgeBasis(phiRef, aRef, phiQue, aQue);   
    elseif strcmp(mode,'decompose')
        phiQueryCorrected = phiQue;
        aQueryCorrected = aQue;
    else
        fprintf('Choose correct mode\n');
    end
    
    if param.verbose
        displayComponents(phiQueryCorrected,aQueryCorrected,phiRef,aRef,size(query),size(reference)); 
        suptitle('After Basis Transformation/Replacement');
    end
      
end