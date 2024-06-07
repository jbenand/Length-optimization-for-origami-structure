%------------- Approximate workspace volume to pyramid with hexagonal base --------------

% input: the positions in the workspace
% ouput: the volume of the workspacem the ranges in x, y and z

function [volume] = workspace_volume(dataMatrix)
    [~, volume] = convhull(dataMatrix);
end