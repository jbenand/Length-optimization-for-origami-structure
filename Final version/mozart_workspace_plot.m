
function [] = mozart_workspace_plot(axesHandle, r)

disp('Started plotting');

fixed_phi = pi/6:pi/2;

%the angle of the leg
phi1=pi/6:pi/30:pi/2;
phi2=pi/6:pi/30:pi/2;
phi3=pi/6:pi/30:pi/2;
maxRows=round((pi/2-pi/6)/pi/60);
rowIndex = 1;
dataMatrix = zeros(maxRows, 3);
% orientation = zeros(length(phi1)*length(phi2)*length(phi3), 1);
% angle = zeros(length(phi1)*length(phi2)*length(phi3), 1);
% max_orientation = 0;

% Set hold on for sets to accumulate on the plot
hold(axesHandle, 'on');

% Fix leg 1 to 30 and 90 degrees
for x=fixed_phi
    for y=phi2
        for z=phi3
            [p,~]=Modified_Forward_Kinematics_pushbutton(x,y,z,r);
            
            dataMatrix(rowIndex, :) = p.';
            % [orientation(rowIndex), angle(rowIndex)] = orientation_computation(p,N);
            rowIndex=rowIndex+1;
            scatter3(axesHandle, p(1),p(2),p(3),'red','*','LineWidth',4);

            % hold on

            % xlabel('x[m]')
            % ylabel('y[m]')
            % zlabel('z[m]')
        end
    end
end

% Fix leg 2 to 30 and 90 degrees
for x=phi1
    for y=fixed_phi
        for z=phi3
            [p,~]=Modified_Forward_Kinematics_pushbutton(x,y,z,r);
            
            dataMatrix(rowIndex, :) = p.';
            % [orientation(rowIndex), angle(rowIndex)] = orientation_computation(p,N);
            rowIndex=rowIndex+1;
            scatter3(axesHandle, p(1),p(2),p(3),'red','*','LineWidth',4);

            % hold on
            % 
            % xlabel('x[m]')
            % ylabel('y[m]')
            % zlabel('z[m]')
        end
    end
end

% Fix leg 3 to 30 and 90 degrees
for x=phi1
    for y=phi2
        for z=fixed_phi
            [p,~]=Modified_Forward_Kinematics_pushbutton(x,y,z,r);
            
            dataMatrix(rowIndex, :) = p.';
            % [orientation(rowIndex), angle(rowIndex)] = orientation_computation(p,N);
            rowIndex=rowIndex+1;
            scatter3(axesHandle, p(1),p(2),p(3),'red','*','LineWidth',4);

            % hold on
            % 
            % xlabel('x[m]')
            % ylabel('y[m]')
            % zlabel('z[m]')
        end
    end
end

% [~,workspace_volume] = convhull(dataMatrix);

trisurf(convhull(dataMatrix), dataMatrix(:,1), dataMatrix(:,2), dataMatrix(:,3), 'FaceAlpha', 0.5, 'Parent', axesHandle);


grid(axesHandle, 'on'); 
axis(axesHandle, 'square');

hold(axesHandle, 'off');

xlabel(axesHandle, 'x[m]');
ylabel(axesHandle, 'y[m]');
zlabel(axesHandle, 'z[m]');

disp('Finished plotting');

end
