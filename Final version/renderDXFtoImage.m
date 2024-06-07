function img = renderDXFtoImage(dxfFilePath)
    % Read the DXF file
    data = read_DXF(dxfFilePath);
    
    % Create a new figure (offscreen) for rendering the DXF
    fig = figure('Visible', 'off');
    ax = axes(fig);
    
    % Plot the DXF data
    mapshow(ax, data);
    
    % Capture the plot as an image
    frame = getframe(ax);
    img = frame.cdata;
    
    % Close the offscreen figure
    close(fig);
end
