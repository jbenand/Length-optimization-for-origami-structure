classdef semester_project_spring_2024 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        StatusLabel               matlab.ui.control.Label
        OptimizationResultsPanel  matlab.ui.container.Panel
        MaxOrientationLabel       matlab.ui.control.Label
        WorkspaceVolumeLabel      matlab.ui.control.Label
        FinalLengthLabel          matlab.ui.control.Label
        ParallelStructureOptimizationLabel  matlab.ui.control.Label
        Image                     matlab.ui.control.Image
        InputparametersPanel      matlab.ui.container.Panel
        LegLengthEditField        matlab.ui.control.NumericEditField
        LegLengthEditFieldLabel   matlab.ui.control.Label
        MaximumREditField         matlab.ui.control.NumericEditField
        MaximumREditFieldLabel    matlab.ui.control.Label
        MinimumREditField         matlab.ui.control.NumericEditField
        MinimumREditFieldLabel    matlab.ui.control.Label
        OptimizeButton            matlab.ui.control.Button
        UIAxes2                   matlab.ui.control.UIAxes
        UIAxes                    matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        r_min % Variable to store minimum r length
        r_max % Variable to store maximum r length
        l % Variable to store leg length
    end 

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Update the status label
            app.StatusLabel.Text = 'Please select input parameters';

            % Update the initial texts
            app.LegLengthEditFieldLabel.Text = 'Leg length (m) :';
            app.MaximumREditFieldLabel.Text = 'Maximum r (m) :';
            app.MinimumREditFieldLabel.Text = 'Minimum r (m) :' ;
            app.FinalLengthLabel.Text = 'Final r length (m) :';
            app.WorkspaceVolumeLabel.Text = 'Workspace volume (m^3) :';
            app.MaxOrientationLabel.Text = 'Max end effector orientation (°) :';
        end
        
        % Value changed function: MinimumREditField
        function MinimumREditFieldValueChanged(app, event)
            value = app.MinimumREditField.Value;
            app.r_min = value;
            disp(app.r_min);
        end

        % Value changed function: MaximumREditField
        function MaximumREditFieldValueChanged(app, event)
            value = app.MaximumREditField.Value;
            app.r_max = value;
            disp(app.r_max);
        end

        % Value changed function: LegLengthEditField
        function LegLengthEditFieldValueChanged(app, event)
            value = app.LegLengthEditField.Value;
            app.l = value;
            disp(app.l);
        end

        % Run this function when optimize button is pushed
        function OptimizeButtonPushed(app, event)
            % Disable the button to prevent multiple runs
            app.RunButton.Enable = 'off';
            
            try
                % Update the status label
                app.StatusLabel.Text = 'Running optimization...';

                % Run the optimization function asynchronously
                app.future = parfeval(@app.optimizeAndPlot, 3, app.r_min, app.r_max, app.l, app.UIAxes, app.UIAxes2);

                % Add a callback to handle completion
                afterEach(app.future, @(result) app.handleResults(result), 0);

            catch err
                % Display error message
                app.StatusLabel.Text = ['Error: ', err.message];
                % Re-enable the button
                app.RunButton.Enable = 'on';
            end
        end

        % Function to handle results after async execution
        function handleResults(app, result)
            try
                % Fetch the results
                finalLegLength = result{1};
                workspaceVolume = result{2};
                maxOrientation = result{3};

                % Update the UI with results
                app.FinalLengthLabel.Text = ['Final r length (m): ', num2str(finalLegLength)];
                app.WorkspaceVolumeLabel.Text = ['Workspace volume (m^3): ', num2str(workspaceVolume)];
                app.MaxOrientationLabel.Text = ['Max end effector orientation (°): ', num2str(maxOrientation)];

                % Update status
                app.StatusLabel.Text = 'Optimization completed.';
            catch err
                % Display error message
                app.StatusLabel.Text = ['Error: ', err.message];
            end
            
            % Re-enable the button
            app.RunButton.Enable = 'on';
        end

        % Asynchronous function to optimize and plot
        function [finalLegLength, workspaceVolume, maxOrientation] = optimizeAndPlot(app)
            % Add try-catch block for debugging
            try
                disp('Starting genetic algorithm...');
                % Run the optimization function to get the final leg length
                [finalLegLength,workspaceVolume,maxOrientation] = genetic_algorithm(app.r_min,app.r_max,app.l);
                disp(['Final leg length: ', num2str(finalLegLength)]);
                disp(['Workspace volume: ', num2str(workspaceVolume)]);
                disp(['Max orientation: ', num2str(maxOrientation)]);
        
                % Call the function to plot the workspace and get additional results
                % [workspaceVolume, maxOrientation] = plotWorkspace(uiAxes, finalLegLength);
                mozart_workspace_plot(app.UIAxes,finalLegLength);
                % disp(['Workspace volume: ', num2str(workspaceVolume)]);
                % disp(['Max orientation: ', num2str(maxOrientation)]);
        
                % Render and display the DXF file
                dxfFilePath = 'final_cut.dxf'; % Replace with actual path
                img = renderDXFtoImage(dxfFilePath);
                imshow(img, 'Parent', app.UIAxes2);
            catch err
                disp(['Error during optimizeAndPlot: ', err.message]);
                rethrow(err);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [16 25 300 185];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Title')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Box = 'on';
            app.UIAxes2.Position = [315 25 300 185];

            % Create InputparametersPanel
            app.InputparametersPanel = uipanel(app.UIFigure);
            app.InputparametersPanel.Title = 'Input parameters';
            app.InputparametersPanel.FontWeight = 'bold';
            app.InputparametersPanel.Position = [65 227 251 179];

            % Create OptimizeButton
            app.OptimizeButton = uibutton(app.InputparametersPanel, 'push');
            app.OptimizeButton.ButtonPushedFcn = createCallbackFcn(app, @OptimizeButtonPushed, true);
            app.OptimizeButton.Position = [76 15 100 23];
            app.OptimizeButton.Text = 'Optimize';

            % Create MinimumREditFieldLabel
            app.MinimumREditFieldLabel = uilabel(app.InputparametersPanel);
            app.MinimumREditFieldLabel.HorizontalAlignment = 'right';
            app.MinimumREditFieldLabel.Position = [10 122 119 22];
            app.MinimumREditFieldLabel.Text = 'Minimum R';

            % Create MinimumREditField
            app.MinimumREditField = uieditfield(app.InputparametersPanel, 'numeric');
            app.MinimumREditField.ValueChangedFcn = createCallbackFcn(app, @MinimumREditFieldValueChanged, true);
            app.MinimumREditField.Position = [136 122 73 22];

            % Create MaximumREditFieldLabel
            app.MaximumREditFieldLabel = uilabel(app.InputparametersPanel);
            app.MaximumREditFieldLabel.HorizontalAlignment = 'right';
            app.MaximumREditFieldLabel.Position = [10 87 119 22];
            app.MaximumREditFieldLabel.Text = 'Maximum R';

            % Create MaximumREditField
            app.MaximumREditField = uieditfield(app.InputparametersPanel, 'numeric');
            app.MaximumREditField.ValueChangedFcn = createCallbackFcn(app, @MaximumREditFieldValueChanged, true);
            app.MaximumREditField.Position = [136 87 73 22];

            % Create LegLengthEditFieldLabel
            app.LegLengthEditFieldLabel = uilabel(app.InputparametersPanel);
            app.LegLengthEditFieldLabel.HorizontalAlignment = 'right';
            app.LegLengthEditFieldLabel.Position = [10 51 119 22];
            app.LegLengthEditFieldLabel.Text = 'Leg Length';

            % Create LegLengthEditField
            app.LegLengthEditField = uieditfield(app.InputparametersPanel, 'numeric');
            app.LegLengthEditField.ValueChangedFcn = createCallbackFcn(app, @LegLengthEditFieldValueChanged, true);
            app.LegLengthEditField.Position = [136 51 73 22];

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [16 405 100 100];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'Images', 'EPFL_logo.png');

            % Create ParallelStructureOptimizationLabel
            app.ParallelStructureOptimizationLabel = uilabel(app.UIFigure);
            app.ParallelStructureOptimizationLabel.FontSize = 20;
            app.ParallelStructureOptimizationLabel.FontWeight = 'bold';
            app.ParallelStructureOptimizationLabel.Position = [170 442 301 26];
            app.ParallelStructureOptimizationLabel.Text = 'Parallel Structure Optimization';

            % Create OptimizationResultsPanel
            app.OptimizationResultsPanel = uipanel(app.UIFigure);
            app.OptimizationResultsPanel.Title = 'Optimization Results';
            app.OptimizationResultsPanel.FontWeight = 'bold';
            app.OptimizationResultsPanel.Position = [343 227 264 144];

            % Create FinalLengthLabel
            app.FinalLengthLabel = uilabel(app.OptimizationResultsPanel);
            app.FinalLengthLabel.Position = [22 73 199 22];
            app.FinalLengthLabel.Text = 'Final Length';

            % Create WorkspaceVolumeLabel
            app.WorkspaceVolumeLabel = uilabel(app.OptimizationResultsPanel);
            app.WorkspaceVolumeLabel.Position = [22 52 199 22];
            app.WorkspaceVolumeLabel.Text = 'Workspace Volume';

            % Create MaxOrientationLabel
            app.MaxOrientationLabel = uilabel(app.OptimizationResultsPanel);
            app.MaxOrientationLabel.Position = [22 31 199 22];
            app.MaxOrientationLabel.Text = 'Max Orientation';

            % Create StatusLabel
            app.StatusLabel = uilabel(app.UIFigure);
            app.StatusLabel.Position = [402 336 599 101];
            app.StatusLabel.Text = 'StatusLabel';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = semester_project_spring_2024

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end