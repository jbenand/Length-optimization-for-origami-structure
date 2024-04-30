%------------- Approximate workspace area to regular hexagon --------------

% input: the positions in the workspace
% ouput: the area of the workspace in xy plane, the range in x and y

function [area, x_range, y_range] = workspace_area(dataMatrix)
    % find the maximum and minimum x coordinate
    max_x = max(dataMatrix(:,1));
    min_x = min(dataMatrix(:,1));
    % find the maximum and minimum y coordinate
    max_y = max(dataMatrix(:,2));
    min_y = min(dataMatrix(:,2));

    % return the ranges in x and y
    x_range = max_x-min_x;
    y_range = max_y-min_y;

    % find the length of a side of the regular hexagon
    l_side = x_range/(1+2*cos(pi/3));
    
    % return the area of a regular hexagon
    area = (3*sqrt(3)/2)*l_side^2;
end