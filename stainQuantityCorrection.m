function aQueryNorm = stainQuantityCorrection(aReference, aQuery,quantityPercentile)
%%%%%%%%%%%%%%%% Stain Quantity Correction %%%%%%%%%%%%%%
%normalizes the stain concentrations using histogram normalization
%===================  INPUT ===================
% aReference : concentration matrix for reference
% aQuery : concentration matrix for query
% quantityPercentile : Match the (quantityPercentile)th percentile of the
%                      concentration matrix for each row
%===================  OUTPUT ===================
% aQueryNorm    : normalized concentration matrix
%===============================================

    % Find the nth percentile of stain concentration for query
    maxQuery = prctile(aQuery, quantityPercentile, 2);

    % Find the nth percentile of stain concentration for reference
    maxReference = prctile(aReference, quantityPercentile, 2);


    aQueryNorm = bsxfun(@rdivide, aQuery, maxQuery);
    aQueryNorm = bsxfun(@times,   aQueryNorm, maxReference);
end