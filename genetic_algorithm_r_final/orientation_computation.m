%------------- Compute orientation of the end effector ----------------

% input: N the orthogonal vector to the virtual plane
% ouput: the orientation of the end effector

function [orientation] = orientation_computation(N)
    z_axis = [0, 0, 1];
    dot_product = dot(N, z_axis);
    
    % Compute the magnitudes of the two vectors
    magnitude_N = norm(N);
    magnitude_z = norm(z_axis);
    
    % Compute the cosine of the angle between the vectors
    cosine_orientation = dot_product / (magnitude_N * magnitude_z);
    
    % Compute the angle in radians using the arccosine function
    orientation_rad = acos(cosine_orientation);
    
    % Convert the angle from radians to degrees if needed
    orientation = rad2deg(orientation_rad);    
end