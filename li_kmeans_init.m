function init = li_kmeans_init(image,mask_1,mask_2,mask_3)

    init = zeros([3,1]);
    
    image_hsv = rgb2hsv(image);
    image_s = image_hsv(:,:,2);
    
    [~,~,image_1_val] = find(double(image_s) .* double(sum(mask_1,3)==255*3));
    [~,~,image_2_val] = find(double(image_s) .* double(sum(mask_2,3)==255*3));
    [~,~,image_3_val] = find(double(image_s) .* double(sum(mask_3,3)==255*3));
    
    init(1) = mean(image_1_val) * 360;
    init(2) = mean(image_2_val) * 360;
    init(3) = mean(image_3_val) * 360;
end