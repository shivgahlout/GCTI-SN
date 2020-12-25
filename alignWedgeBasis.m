function [phiQueryAligned, aQueryAligned] = alignWedgeBasis(phiRefW, aRefW, phiQueW, aQueW)
%%%%%%%%%%%%%%%% alignWedgeBasis %%%%%%%%%%%%%%
%Aligns the wedge basis of query wrt reference
%===================  INPUT ===================
% phiRefW : stain vectors (wedge) for Reference
% aRefW : concentration matrix for reference
% phiQueW : stain vectors (wedge) for Query
% aQueW : concentration matrix for query
%===================  OUTPUT ===================
% phiQueryAligned : aligned stain vectors for Query
% aQueryAligned : corrected concentration matrix for query 
%===============================================

    phiQueryAligned = phiQueW;
    aQueryAligned = aQueW;
    phiR = phiRefW(:,[1 2]);
    phiQ = phiQueW(:,[1 2]);    
    aR = aRefW([1 2],:);
    aQ = aQueW([1 2],:);
    pixelCount = size(aQueW,2);
    
    normal = cross(phiR(:,1),phiR(:,2))/norm(cross(phiR(:,1),phiR(:,2)));
    theta = atan2(norm(cross(phiQ(:,1), phiQ(:,2))), dot(phiQ(:,1), phiQ(:,2))); % angle of query wedge
    alpha = atan2(norm(cross(phiR(:,1), phiR(:,2))), dot(phiR(:,1), phiR(:,2))); % angle of ref wedge     
    
    % align phi1Q and phi1R
    phiQ(:,1) = phiR(:,1);
    temp = rodrigues_rot_matrix([phiQ(:,1)],normal,theta); %determine updated phi_2
    phiQ(:,2) = temp(:,1); 
    if size(phiQueW,2) == 3 %if phi_3 exists, find its new position  
        %project old_phi_3 onto plane of old_phi_1 and old_phi_2
        old_normal = cross(phiQueW(:,1),phiQueW(:,2))/norm(cross(phiQueW(:,1),phiQueW(:,2)));
        projection = phiQueW(:,3) - old_normal * dot(phiQueW(:,3),old_normal);   
        angle_2_sign = sign(dot(cross(phiQueW(:,1),phiQueW(:,2)),phiQueW(:,3)));
        if norm(projection) < 1e-6 % in this case phi_3 is mostly orthogonal to phi_1 and phi_2
            angle_1 = 0;
            angle_2 = angle_2_sign * (pi/2); 
        else
            angle_1 = atan2(veclen(cross(phiQueW(:,1),projection)), dot(phiQueW(:,1),projection)); %angle b/w old_phi_1 and projection
            angle_2 = angle_2_sign * atan2(veclen(cross(projection, phiQueW(:,3))), dot(projection, phiQueW(:,3))); %angle b/w projection and old_phi_3
        end
        
        new_projection = rodrigues_rot_matrix([phiQ(:,1)],normal,angle_1); %find new projection
        new_phi_3 = rodrigues_rot_matrix(new_projection,cross(new_projection(:,1),normal),angle_2); %lift projection to get updated phi_3
        phiQueryAligned(:,3) = new_phi_3(:,1);
    end
    queryImg = phiQ * aQ;

    %stretch and align phi2Q with phi2R
    angleRatio = alpha/theta;
    currentAngle = atan2(dot(cross(repmat(phiR(:,1),1,pixelCount),queryImg),repmat(normal,1,pixelCount)),dot(queryImg,repmat(phiR(:,1),1,pixelCount))); % angle of each pixel wrt phiR1
    resultAngle = currentAngle * angleRatio;
    queryImg = rodrigues_rot_matrix(phiQ(:,1), normal, resultAngle).*repmat(sqrt(sum(queryImg.^2)),3,1); % get rotated image
    temp = rodrigues_rot_matrix([phiQ(:,1)],normal,alpha);
    phiQ(:,2) = temp(:,1);
    
    %project image back onto stretched basis
    phiQueryAligned(:,[1 2]) = phiQ;    
    aQueryAligned([1,2],:) = pinv(phiQueryAligned(:,[1 2])) * queryImg;
        
end

function mag = veclen(V)
    mag=sqrt(sum(V.*V));
end