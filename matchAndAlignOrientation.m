function [aMatched, phiMatched] = matchAndAlignOrientation(phiQuery, phiReference, aQuery, aReference, querySize, referenceSize, verbose)    
%%%%%%%%%%%%%%%% matchAndAlignOrientation %%%%%%%%%%%%%%
%Jointly aligns and orients the query basis
%===================  INPUT ===================
% phiQuery : stain vectors (orthogonal) for Query
% phiReference : stain vectors (orthogonal) for Reference
% aQuery : concentration matrix for query
% aReference : concentration matrix for reference
%===================  OUTPUT ===================
% phiMatched : aligned stain vectors (orthogonal) for Query
% aMatched : corrected concentration matrix for query 
%===============================================
   
   if size(aQuery,1) == 3
       queryPerms = [[1,2,3];[1,3,2];[2,1,3];[2,3,1];[3,1,2];[3,2,1]];
       queryMask = [[1,1,1];[-1,1,1];[1,-1,1];[1,1,-1]];
   end
   if size(aQuery,1) == 2
       queryPerms = [[1,2];[2,1];];
       queryMask = [[1,1];[1,-1];];
   end

    minPerm = [1,2,3];
    minDist = 1000000;
        
    for i = 1:size(queryPerms,1)
        for j = 1:size(queryMask,1)
            currPermutation = queryPerms(i,:);
            currDist = 0;
            
            for k = 1:size(currPermutation,2)
                queryPhi = phiQuery(:,currPermutation(k)) * queryMask(j,k);
                currDist = currDist + immse(phiReference(:,k), queryPhi); %calculate mean square error               
            end
                 
            if currDist < minDist
                minPerm = currPermutation .* queryMask(j,:);
                minDist = currDist;
            end
        end 
    end
    
    for k=1:size(minPerm,2)
        phiMatched(:,k) = sign(minPerm(k)) * phiQuery(:,abs(minPerm(k)));
        aMatched(k,:) = sign(minPerm(k)) * aQuery(abs(minPerm(k)),:);
        
    end     
end
