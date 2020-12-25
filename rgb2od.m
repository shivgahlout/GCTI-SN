function od = rgb2od(rgb) 
    rgb(rgb==0) = min(rgb(rgb>0));
    od = -log(rgb);
%     [h,w,d] = size(rgb);
%         
%     Ib = reshape(Ib,[1,1,d]);
%     
%     I_by_Ib = rgb ./ repmat(Ib,[h,w,1]);  
%     
%     %suppress pixels with intensities greater than average background
% %     mask = repmat(sum(I_by_Ib>1,3)>0,[1,1,d]);
% %     I_by_Ib(mask) = 1;
% 
%     od = -log10(I_by_Ib);
end