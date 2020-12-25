function [p_val, kstat] = calcODKstat_new(phiQuery,aQuery,phiReference,aReference,color,querySize,referenceSize,param)
    
    r = 1;
    kstat = [0,0,0];
    p_val = [0,0,0];
    
    for i=1:size(aQuery,1)
        
        phiQuerySingleStain = zeros(size(phiQuery));
        phiQuerySingleStain(:,i) = phiQuery(:,i);
        phiReferenceSingleStain = zeros(size(phiReference));
        phiReferenceSingleStain(:,i) = phiReference(:,i);

        querySingleStainImage = sum(phiQuerySingleStain * aQuery);
        referenceSingleStainImage = sum(phiReferenceSingleStain * aReference);
        
%         subplot(2,3,i);
%         imshow((od2rgb(reshape((phiQuerySingleStain * aQuery)', querySize))));
%         subplot(2,3,i+3);
%         imshow((od2rgb(reshape((phiReferenceSingleStain * aReference)', referenceSize))));
               
        [~,~,que_val] = find(querySingleStainImage);
        [~,~,ref_val] = find(referenceSingleStainImage); 
        
        [h,p,ks2stat] = kstest2(datasample(que_val,round(r*size(que_val,2)),'Replace',false),...
                                datasample(ref_val,round(r*size(ref_val,2)),'Replace',false));                            
        
        p_val(i) = p;
        kstat(i) = ks2stat;    
    end
end