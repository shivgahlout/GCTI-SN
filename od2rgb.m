function rgb = od2rgb(od)
    rgb = exp(-od);
%     [h,w,d] = size(od);
%     Ib = reshape(Ib,[1,1,d]);
%     
%     rgb = repmat(Ib,[h,w,1]) .* (10.^-od);
end