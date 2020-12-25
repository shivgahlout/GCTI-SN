function rmse = RMSE(query,reference,params)
     
    %%% for ALL and MM images %%%%%
    que_roi = double(query) .* repmat(double(sum(params.que_mask,3)==255*3),[1,1,3]);
    ref_roi = double(reference) .* repmat(double(sum(params.ref_mask,3)==255*3),[1,1,3]);
    
  
%     figure;
%     subplot(1,2,1);
%     imshow(ref_roi);
%     subplot(1,2,2);
%     imshow(que_roi);
       
    mse_que = zeros([1,size(query,3)]);
    mse_ref = zeros([1,size(reference,3)]);
        
    for i=1:size(query,3)
        [~,~,val_que] = find(que_roi(:,:,i));
        [~,~,val_ref] = find(ref_roi(:,:,i));
        
        mse_que(i) = mean(uint8(val_que*255));
        mse_ref(i) = mean(uint8(val_ref*255));
    end
    
%     mse_que
%     mse_ref
    rmse = sqrt(sum((mse_que-mse_ref).^2));
end