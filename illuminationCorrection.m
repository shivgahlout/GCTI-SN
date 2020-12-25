function [Icorrected1,Icorrected2,ref1] = illuminationCorrection(query,reference)
%%%%%%%%%%%%%%%% illuminationCorrection %%%%%%%%%%%%%%
% Implements the illumination correction module defined in the paper
%===================  INPUT ===================
% query : RGB query image
% reference : RGB reference Image
%===================  OUTPUT ===================
% Icorrected : Illumination corrected RGB query image
%===============================================

    % apply median filtering
    query_mf = query;
    reference_mf = reference;    
    for i=1:size(query,3)
        query_mf(:,:,i) = medfilt2(query_mf(:,:,i));
        reference_mf(:,:,i) = medfilt2(reference_mf(:,:,i));
    end
        
    % generate grayscale image
    query_gray = generateCompositeImage(query_mf);
    reference_gray = generateCompositeImage(reference_mf); 
        
    % apply kernel filter and determine background locations   
    kSize = [71,51,31,11];
    P = 99;
    
    for i=1:size(kSize)
        query_conv = applyKernel(query_gray,kSize(i));
        query_loc = getPercentileLocations(query_conv,P); 
        
        if(sum(sum(query_loc)) > 100)
            break
        end
    end      
    for i=1:size(kSize)
        reference_conv = applyKernel(reference_gray,kSize(i)); 
        reference_loc = getPercentileLocations(reference_conv,P);
        
        if(sum(sum(reference_loc)) > 100)
            break
        end
    end  
    
    
    % find R,G,B means in P percentile locations
    query_rgb_mean = zeros(size(query,3),1);
    reference_rgb_mean = zeros(size(reference,3),1);    
    for i=1:size(query_rgb_mean)
        query_channel = query(:,:,i);
        query_rgb_mean(i) = mean(query_channel(query_loc));
        
        reference_channel = reference(:,:,i);
        reference_rgb_mean(i) = mean(reference_channel(reference_loc)); 
        
        query(:,:,i) = query_channel;
        reference(:,:,i) = reference_channel;       
        
    end
            
    % normalize query
    Icorrected1 = query;
     Icorrected2 = query;
     ref1=reference;
    for i=1:size(query,3)
        Icorrected1(:,:,i)  = Icorrected1(:,:,i) * (reference_rgb_mean(i) / query_rgb_mean(i));
        Icorrected2(:,:,i)  = Icorrected2(:,:,i)/ query_rgb_mean(i);
        ref1(:,:,i)=ref1(:,:,i)/reference_rgb_mean(i);
    end     
end

function img = generateCompositeImage(image)
    img = 1/3 * sqrt(sum(image.^2,3));
end

function img = applyKernel(image,N)    
    img = 1/(N * N) * convn(image,ones(N,N),'same');
end

function locations = getPercentileLocations(image,P)
    image = uint8(image * 255);
    loc = (image>0);
    percentileIndex = round(sum(sum(loc)) * (P/100));
    sortedImageIntesities = sort(image(loc));
    locations = (image == sortedImageIntesities(percentileIndex));
end
