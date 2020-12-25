% rodrigues_rot - Rotates array of 3D vectors by an angle theta about vector k.
% Direction is determined by the right-hand (screw) rule.
%
% Syntax:  v_rot = rodrigues(v,k,theta)
%
% Inputs:
%    v - Array of three dimensional vectors to rotate. Array can be 
%           composed of N rows of 3D row vectors or N columns of 3D column
%           vectors. If v is 3x3 array, it is assumed that it is 3 rows of
%           3 3D row vectors.
%    k - Rotation axis (does not need to be unit vector)
%    theta - Rotation angle in radians; positive according to right-hand
%           (screw) rule
%
%   Note: k and individual 3D vectors in v array must be same orientation.
%           
%
% Outputs:
%    v_rot - Array of rotated vectors.
%
% Other m-files required: dot.m (built-in MATLAB)
% Subfunctions: none
% MAT-files required: none
%
% Author: Ismail Hameduddin
%           Mechanical Engineering, Purdue University
% email: ihameduddin@gmail.com
% Website: http://www.ismailh.com
% January 2011; Last revision: 2-January-2012

%------------- BEGIN CODE --------------

function v_rot = rodrigues_rot_matrix(v,k,theta)
    [m,n] = size(v);
    if (m ~= 3 && n ~= 3)
        error('input vector is/are not three dimensional'), end
    if (size(v) ~= size(k)) 
        error('rotation vector v and axis k have different dimensions'),end
    
    k = k/sqrt(k(1)^2 + k(2)^2 + k(3)^2); % normalize rotation axis
    No = numel(v)/3; % number of vectors in array
    
    [m_theta, n_theta] = size(theta);
    %v_rot(:,:) = v; % initialize rotated vector array
    
    v_rot = repmat(v,1,n_theta); % initialize rotated vector array
    
    if ( n == 3 )
        crosskv = v(1,:); % initialize cross product k and v with right dim.
        for i = 1:No
            crosskv(1) = k(2)*v(i,3) - k(3)*v(i,2);
            crosskv(2) = k(3)*v(i,1) - k(1)*v(i,3); 
            crosskv(3) = k(1)*v(i,2) - k(2)*v(i,1);
            v_rot(i,:) = cos(theta)*v(i,:) + (crosskv)*sin(theta)...
                            + k*(dot(k,v(i,:)))*(1 - cos(theta));
        end
    else % if m == 3 && n ~= 3
        crosskv = v(:,1); % initialize cross product k and v with right dim.
%         for i = 1:No
            crosskv(1) = k(2)*v(3,1) - k(3)*v(2,1);
            crosskv(2) = k(3)*v(1,1) - k(1)*v(3,1); 
            crosskv(3) = k(1)*v(2,1) - k(2)*v(1,1);
            theta_t = theta';
            
%             v_rot(:,i) = cos(theta)*v(:,i) + (crosskv)*sin(theta)...
%                             + k*(dot(k,v(:,i)))*(1 - cos(theta));
            
            v_rot(:,:) = (cos(theta_t)*v(:,1)' + sin(theta_t)*(crosskv')...
                            + (1 - cos(theta_t))*(k*(dot(k,v(:,1))))')';
%         end
    end
end

%------------- END OF CODE --------------
