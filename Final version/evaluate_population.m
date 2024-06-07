%------------- Evaluate the fitness of each member ----------------

% input: the population and population size
% ouput: the fitness of each member of the population

function [population_fitness] = evaluate_population(population, population_size)
    %the angle of the leg
    phi1=pi/6:pi/30:pi/2;
    phi2=pi/6:pi/30:pi/2;
    phi3=pi/6:pi/30:pi/2;
    maxRows=round((pi/2-pi/6)/pi/60);
    rowIndex = 1;
    dataMatrix = zeros(maxRows, 3);
    population_fitness = zeros(population_size,2);
    %population_orientation = zeros(population_size, 1);
    %population_volume = zeros(population_size, 1);
    
    % Evaluate the workspace area for each member of the population
    for i = 1:1:population_size
        orientation = zeros(maxRows, 1);
        for x=phi1
            for y=phi2
                for z=phi3
                    [p,N]=Modified_Forward_Kinematics_pushbutton(x,y,z,population(i,1));
                    
                    dataMatrix(rowIndex, :) = p.';
                    orientation(rowIndex) = orientation_computation(N);
                    rowIndex=rowIndex+1;
                end
            end
        end
        rowIndex = 1;
        % population_fitness(i,1) = workspace_area(dataMatrix);
        population_fitness(i,1) = workspace_volume(dataMatrix);
        population_fitness(i,2) = max(abs(orientation));
        %population_orientation(i) = max(abs(orientation));
        %population_volume(i) = workspace_volume(dataMatrix);
    end
end