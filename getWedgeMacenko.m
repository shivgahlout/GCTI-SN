function [phiWedge aWedge] = getWedgeMacenko(imageRGB,squeezePercentile)
    %this function finds the wedge in the phi1,phi2 plane
    
    [phiOrthogonal aOrthogonal] = getOrthogonalMacenko(imageRGB); 
       
    imageOD = phiOrthogonal*aOrthogonal;
    phiWedge = phiOrthogonal;
    phiPlane = phiOrthogonal(:,[1 2]); 
    aPlane = aOrthogonal([1 2],:); % project aOrthogonal onto plane    
        
    % normalize aPlane
    aPlaneNormalized = normc(aPlane(:,:));    
        
    % find robust extreme angles
    minA = prctile(atan(aPlaneNormalized(2,:)./aPlaneNormalized(1,:)), squeezePercentile);
    maxA = prctile(atan(aPlaneNormalized(2,:)./aPlaneNormalized(1,:)), 100-squeezePercentile); 

    % rotate to obtain robust extremes
    phi1 =  rodrigues_rot(phiPlane(:,1), cross(phiPlane(:,1),phiPlane(:,2)), minA);
    phi2 =  rodrigues_rot(phiPlane(:,1), cross(phiPlane(:,1),phiPlane(:,2)), maxA); 
    
    phiWedge(:,[1 2]) = normc([phi1 phi2]);      
    aWedge = pinv(phiWedge) * imageOD;
    
    

end
