function rmse = calcQQPlotODRMSE_new(phiQuery,aQuery,phiReference,aReference,querySize,referenceSize,param)
    
    r = 1;
    rmse = [0,0,0];    
    
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
               
        f = figure;

        [~,~,que_val] = find(querySingleStainImage);
        [~,~,ref_val] = find(referenceSingleStainImage);    

                
        a = qqplot(datasample(que_val,round(r*size(que_val,2)),'Replace',false),...
                   datasample(ref_val,round(r*size(ref_val,2)),'Replace',false));
        
        X = a(1).XData;
        Y = a(1).YData;
        rmse_channel = mean(abs(X-Y)/sqrt(2));  
        rmse(i) = rmse_channel; 
        
        close(f);
    end
end