%------------- Draw structure ----------------

% input: r and l
% ouput: dxf file
% This function produces a dxf file of the origami structure to be used to
% manufacture the origami structure

function drawing = draw_origami(r, l, axesHandle)

    % Convert r and l to mm
    r = 1000*r;
    l = 1000*l;

    % Initialize necessary variables
    width = (2*r/tan(pi/6))*(1+cos(pi/3)+(sin(pi/3)/tan(pi/6)))^(-1);
    width_r = (width/2)*cos(pi/3);
    height_r = (width/2)*sin(pi/3);
    fold_width = 1;
    fold_angle = pi/4;
    precision = 100;

    % Define the circle and arc of circle
    circle_radius = r/pi;
    arc_radius = r/pi;
    fixation_radius = 1.5;
    theta_circle = linspace(0,2*pi,precision);
    theta_arc = linspace(-pi/6,-5*pi/6,precision);

    if width < 50 
        multiplier = 1;
    end
    if width > 50
        if width < 90
            multiplier = 2;
        end
        if width > 90
            multiplier = 3;
        end
    end

    offset = 25;

    %% Final cut

    FID = dxf_open('final_cut.dxf');
    % FID is a structure containing handle to DXF file and parameters that
    % are used by remaining routines. DXFLib is a 'state' library. That means
    % that certain values of parameters (e.g. color, layer) are preserved 
    % between following callings to various routines unless they are changed. 
    % By default, the color is ACI color 255 (white) and the layer
    % number is 0. You can modify state parameters by dxf_set routine.

    % Define precision and number of lines
    lines = 20;

    X = zeros(precision, lines);
    Y = zeros(precision, lines);
    Z = zeros(precision, 1);

    % General shape
    X(:,1) = linspace(0,0,precision);
    Y(:,1) = linspace(0,2*l,precision);
    X(:,2) = linspace(0,-width_r,precision);
    Y(:,2) = linspace(2*l,2*l+height_r,precision);
    X(:,3) = linspace(-width_r,width/2+arc_radius*cos(-5*pi/6),precision);
    Y(:,3) = linspace(2*l+height_r,2*l+r+arc_radius*sin(-5*pi/6),precision);
    X(:,4) = width/2+arc_radius*cos(theta_arc);
    Y(:,4) = 2*l+r+arc_radius*sin(theta_arc);
    X(:,5) = linspace(width/2+arc_radius*cos(-pi/6),width+width_r,precision);
    Y(:,5) = linspace(2*l+r+arc_radius*sin(-pi/6),2*l+height_r,precision);
    X(:,6) = linspace(width+width_r,width,precision);
    Y(:,6) = linspace(2*l+height_r,2*l,precision);
    X(:,7) = linspace(width,width,precision);
    Y(:,7) = linspace(2*l,0,precision);
    X(:,8) = linspace(width,width+width_r,precision);
    Y(:,8) = linspace(0,-height_r,precision);
    X(:,9) = linspace(width+width_r,width/2+arc_radius*cos(pi/6),precision);
    Y(:,9) = linspace(-height_r,-r+arc_radius*sin(pi/6),precision);
    X(:,10) = width/2+arc_radius*cos(-theta_arc);
    Y(:,10) = -r+arc_radius*sin(-theta_arc);
    X(:,11) = linspace(width/2+arc_radius*cos(5*pi/6),-width_r,precision);
    Y(:,11) = linspace(-r+arc_radius*sin(5*pi/6),-height_r,precision);
    X(:,12) = linspace(-width_r,0,precision);
    Y(:,12) = linspace(-height_r,0,precision);
    % Fixation holes
    X(:,13) = 2*fixation_radius+fixation_radius*cos(theta_circle);
    Y(:,13) = -3*fixation_radius+fixation_radius*sin(theta_circle);
    X(:,14) = width-2*fixation_radius+fixation_radius*cos(theta_circle);
    Y(:,14) = Y(:,13);
    X(:,15) = X(:,13);
    Y(:,15) = Y(:,13)+2*l+6*fixation_radius;
    X(:,16) = X(:,14);
    Y(:,16) = Y(:,15);
    % Contour rectangle
    max_x = max(max(X))+offset;
    min_x = min(min(X))-offset;
    max_y = max(max(Y))+offset;
    min_y = min(min(Y))-offset;
    X(:,17) = linspace(min_x,max_x,precision);
    Y(:,17) = linspace(min_y,min_y,precision);
    X(:,18) = linspace(max_x,max_x,precision);
    Y(:,18) = linspace(min_y,max_y,precision);
    X(:,19) = linspace(max_x,min_x,precision);
    Y(:,19) = linspace(max_y,max_y,precision);
    X(:,20) = linspace(min_x,min_x,precision);
    Y(:,20) = linspace(max_y,min_y,precision);
    
    X_final_cut = X;
    Y_final_cut = Y;

    % Draw the polylines
    for i = 1:lines
        dxf_polyline(FID,X(:,i),Y(:,i),Z);
    end
    dxf_polyline(FID,X(:,end),Y(:,end),Z);

    dxf_close(FID);

    %% Kapton

    FID = dxf_open('kapton.dxf');

    lines = 9;

    X = zeros(precision,lines);
    Y = zeros(precision,lines);
    Z = zeros(precision,1);

    % Contour rectangle shape
    X(:,1) = linspace(min_x,max_x,precision);
    Y(:,1) = linspace(min_y,min_y,precision);
    X(:,2) = linspace(max_x,max_x,precision);
    Y(:,2) = linspace(min_y,max_y,precision);
    X(:,3) = linspace(max_x,min_x,precision);
    Y(:,3) = linspace(max_y,max_y,precision);
    X(:,4) = linspace(min_x,min_x,precision);
    Y(:,4) = linspace(max_y,min_y,precision);
    % Fixation holes
    % X(:,5) = min_x+3*fixation_radius+fixation_radius*cos(theta_circle);
    X(:,5) = width/2-multiplier*25+fixation_radius*cos(theta_circle);
    Y(:,5) = fixation_radius*sin(theta_circle);
    % X(:,6) = max_x-3*fixation_radius+fixation_radius*cos(theta_circle);
    X(:,6) = X(:,5)+multiplier*50;
    Y(:,6) = Y(:,5);
    X(:,7) = X(:,5);
    Y(:,7) = 100+fixation_radius*sin(theta_circle);
    X(:,8) = X(:,6);
    Y(:,8) = Y(:,7);
    % Center hole
    X(:,9) = width/2+circle_radius*cos(theta_circle);
    Y(:,9) = l+circle_radius*sin(theta_circle);

    X_kapton = X+max_x+offset;
    Y_kapton = Y;

    % Draw the polylines
    for i = 1:lines
        dxf_polyline(FID,X(:,i),Y(:,i),Z);
        % dxf_polyline(FID,X(:,i+1),Y(:,i+1),Z);
    end
    dxf_polyline(FID,X(:,end),Y(:,end),Z);

    dxf_close(FID);

    %% F4V

    FID = dxf_open('f4v.dxf');

    lines = 29;

    X = zeros(precision,lines);
    Y = zeros(precision,lines);
    Z = zeros(precision,1);

    % Contour rectangle shape
    X(:,1) = linspace(min_x,max_x,precision);
    Y(:,1) = linspace(min_y,min_y,precision);
    X(:,2) = linspace(max_x,max_x,precision);
    Y(:,2) = linspace(min_y,max_y,precision);
    X(:,3) = linspace(max_x,min_x,precision);
    Y(:,3) = linspace(max_y,max_y,precision);
    X(:,4) = linspace(min_x,min_x,precision);
    Y(:,4) = linspace(max_y,min_y,precision);
    % Fixation holes
    % X(:,5) = min_x+3*fixation_radius+fixation_radius*cos(theta_circle);
    X(:,5) = (width/2-multiplier*25)+fixation_radius*cos(theta_circle);
    Y(:,5) = fixation_radius*sin(theta_circle);
    % X(:,6) = max_x-3*fixation_radius+fixation_radius*cos(theta_circle);
    X(:,6) = X(:,5)+multiplier*50;
    Y(:,6) = Y(:,5);
    X(:,7) = X(:,5);
    Y(:,7) = 100+fixation_radius*sin(theta_circle);
    X(:,8) = X(:,6);
    Y(:,8) = Y(:,7);
    % Center hole
    X(:,9) = width/2+circle_radius*cos(theta_circle);
    Y(:,9) = l+circle_radius*sin(theta_circle);
    % Rotary joints
    X(:,10) = linspace(0,width,precision);
    Y(:,10) = linspace(0,0,precision);
    X(:,11) = linspace(width,width,precision);
    Y(:,11) = linspace(0,fold_width,precision);
    X(:,12) = linspace(width,0,precision);
    Y(:,12) = linspace(fold_width,fold_width,precision);
    X(:,13) = linspace(0,0,precision);
    Y(:,13) = linspace(fold_width,0,precision);
    X(:,14) = X(:,10);
    Y(:,14) = Y(:,10)+2*l-fold_width;
    X(:,15) = X(:,11);
    Y(:,15) = Y(:,11)+2*l-fold_width;
    X(:,16) = X(:,12);
    Y(:,16) = Y(:,12)+2*l-fold_width;
    X(:,17) = X(:,13);
    Y(:,17) = Y(:,13)+2*l-fold_width;
    % Spherical joint
    X(:,18) = linspace(0,width,precision);
    Y(:,18) = linspace(l-fold_width/2,l-fold_width/2,precision);
    X(:,19) = linspace(width,width,precision);
    Y(:,19) = linspace(l-fold_width/2,l+fold_width/2,precision);
    X(:,20) = linspace(width,0,precision);
    Y(:,20) = linspace(l+fold_width/2,l+fold_width/2,precision);
    X(:,21) = linspace(0,0,precision);
    Y(:,21) = linspace(l+fold_width/2,l-fold_width/2,precision);
    X(:,22) = X(:,18);
    Y(:,22) = linspace(l-width/2,l+width/2-fold_width/sin(fold_angle),precision);
    X(:,23) = X(:,19);
    Y(:,23) = linspace(l+width/2-fold_width/sin(fold_angle),l+width/2,precision);
    X(:,24) = X(:,20);
    Y(:,24) = linspace(l+width/2,l-width/2+fold_width/sin(fold_angle),precision);
    X(:,25) = X(:,21);
    Y(:,25) = linspace(l-width/2+fold_width/sin(fold_angle),l-width/2,precision);
    X(:,26) = X(:,18);
    Y(:,26) = linspace(l+width/2-fold_width/sin(fold_angle),l-width/2,precision);
    X(:,27) = X(:,19);
    Y(:,27) = linspace(l-width/2,l-width/2+fold_width/sin(fold_angle),precision);
    X(:,28) = X(:,20);
    Y(:,28) = linspace(l-width/2+fold_width/sin(fold_angle),l+width/2,precision);
    X(:,29) = X(:,21);
    Y(:,29) = linspace(l+width/2,l+width/2-fold_width/sin(fold_angle),precision);

    X_f4v = X+2*(max_x+offset);
    Y_f4v = Y;

    % Draw the polylines
    for i = 1:lines
        dxf_polyline(FID,X(:,i),Y(:,i),Z);
        % dxf_polyline(FID,X(:,i+1),Y(:,i+1),Z);
    end
    dxf_polyline(FID,X(:,end),Y(:,end),Z);

    dxf_close(FID);

    drawing = 1;

    %% Plot the drawings to be displayed in the GUI

    hold(axesHandle, 'on');
    % Plot final cut
    for i = 1:length(X_final_cut(1,:))
        plot(axesHandle, X_final_cut(:,i), Y_final_cut(:,i), '-', 'Color', 'b');
    end
    for i = 1:length(X_kapton(1,:))
        plot(axesHandle, X_kapton(:,i), Y_kapton(:,i), '-', 'Color', 'b');
    end
    for i = 1:length(X_f4v(1,:))
        plot(axesHandle,X_f4v(:,i), Y_f4v(:,i), '-', 'Color', 'b');
    end
    hold(axesHandle,'off');
    % Set axis limits
    axis(axesHandle,[min_x 3*max_x min_y max_y]);
    % Maintain aspect ratio
    axis(axesHandle,'equal');

end