function [phiOrthogonal aOrthogonal] = getOrthogonalMacenko(imageRGB)
%%% this function returns an orthogonal basis representation for an image
%%% using svd    
    [m,n,~] = size(imageRGB);        
    imgOD = reshape(rgb2od(imageRGB),m*n,3)';  
    
    %remove pixels below threshold
    imgODNorm = sqrt(sum(imgOD.^2));
    good = imgODNorm>0.15;
    imgODGood = imgOD(:,good);    
         
    [phiOrthogonal, ev, ~] = svds(imgODGood,3,'L');
    phiOrthogonal(:,sum(phiOrthogonal<0)>1) = -phiOrthogonal(:,sum(phiOrthogonal<0)>1); % keep phi positive
    aOrthogonal = pinv(phiOrthogonal) * imgOD;     
   
end

