function [optimized_r, workspace_volume, max_orientation] = genetic_algorithm(r_min, r_max, l, axesHandle)

disp('Started optimizing');
disp(r_min);
disp(r_max);
disp(l);

% Define the population size and parameters
population_size = 80;
selection_size = 10;
mutation_rate = 0.05;
max_generations = 60;
% r_min = 0.01;
% r_max = 0.1;

% l value
% l_default = 0.05940;
l_default = l;

% Initialize the population
population = initialize_population(population_size, r_min, r_max);

% Save initial values for comparison
initial_population = population;
initial_fitness = evaluate_population(initial_population, population_size);

% Initialize some needed variables
workspace_mean = zeros(max_generations, 1);
orientation_mean = zeros(max_generations, 1);
workspace_std = zeros(max_generations, 1);
orientation_std = zeros(max_generations, 1);

% Run the evolution
for i = 1:1:max_generations
    % Evaluate the population
    population_fitness = evaluate_population(population, population_size);
    [pareto_fronts, ~] = fast_nondominated_sort(population_fitness);

    % Compute the mean fitness of the populaiton
    workspace_mean(i) = mean(population_fitness(:,1));
    orientation_mean(i) = mean(population_fitness(:,2));
    workspace_std(i) = std(population_fitness(:,1));
    orientation_std(i) = std(population_fitness(:,2));
    
    % Select the best members of the population
    [selected_population, front_membership, crowding_distance] = population_selection(population, population_fitness, pareto_fronts, population_size);
    
    % Create offspring from the selected individuals
    offspring = generate_offspring(selected_population, selection_size, front_membership, crowding_distance, mutation_rate, r_min);
    
    % Combine the offspring and selected parents to create next generation
    population = [selected_population; offspring];
end

optimized_r = mean(population);
workspace_volume = workspace_mean(max_generations);
max_orientation = orientation_mean(max_generations);

%% Draw DXF file from optimization result

draw_origami(optimized_r, l_default, axesHandle);

disp('Finished optimizing');

end