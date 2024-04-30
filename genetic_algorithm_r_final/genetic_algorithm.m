% Define the population size and parameters
population_size = 200;
selection_size = 10;
mutation_rate = 0.05;
max_generations = 20;
min_r = 0.01;
max_r = 0.1;

% l value
l_default = 0.05940;

% Initialize the population
population = initialize_population(population_size, min_r, max_r);

% Save initial values for comparison
initial_population = population;
initial_fitness = evaluate_population(initial_population, population_size);

% Initialize some needed variables
workspace_mean = zeros(max_generations, 1);
orientation_mean = zeros(max_generations, 1);
test_length = 20;
population_mean = zeros(test_length, 1);
workspace = zeros(test_length, 1);
orientation = zeros(test_length, 1);

for j = 1:test_length

    % Run the evolution
    for i = 1:1:max_generations
        % Evaluate the population
        population_fitness = evaluate_population(population, population_size);
        [pareto_fronts, ~] = fast_nondominated_sort(population_fitness);
    
        % Compute the mean fitness of the populaiton
        workspace_mean(i) = mean(population_fitness(:,1));
        orientation_mean(i) = mean(population_fitness(:,2));
        
        % Select the best members of the population
        [selected_population, front_membership, crowding_distance] = population_selection(population, population_fitness, pareto_fronts, population_size);
        
        % Create offspring from the selected individuals
        offspring = generate_offspring(selected_population, selection_size, front_membership, crowding_distance, mutation_rate, min_r);
        
        % Combine the offspring and selected parents to create next generation
        population = [selected_population; offspring];
    
        if i == 1
            pareto_save = pareto_fronts;
            population_save = population;
            fitness_save = population_fitness;
            selected_save = selected_population;
            membership_save = front_membership;
            save_distance = crowding_distance;
        end
    end

    population_mean(j) = mean(population);
    workspace(j) = workspace_mean(end);
    orientation(j) = orientation_mean(end);

end

%% Plot results

figure;
hold on;
plot(1:test_length, population_mean, '-o');
hold off;
xlabel('Run number');
ylabel('Final r length mean');
title('Optimization result');

%% Plot mean workspace values

figure;
hold on;
plot(1:max_generations, workspace_mean, '-o');
hold off;
xlabel('Generations number');
ylabel('Workspace volume mean');
title('Workspace volume mean vs generation');

%% Plot mean workspace values

figure;
hold on;
plot(1:max_generations, orientation_mean, '-o');
hold off;
xlabel('Generations number');
ylabel('Orientation mean');
title('Orientation mean vs generation');

%% Plot population

figure;
hold on;
plot(1:population_size, population(:,1), '-o');
hold off;
xlabel('Individual index');
ylabel('r and l lengths');
title('Population representation');

%% Plot pareto fronts

figure;
hold on;
for i = 1:length(pareto_fronts)
    front = pareto_fronts{i};
    plot(population_fitness(front, 1), population_fitness(front, 2), 'o', 'DisplayName', sprintf('Front %d', i));
end
hold off;
xlabel('Objective 1');
ylabel('Objective 2');
title('Pareto Fronts');
legend('show');

%% Plot pareto save

figure;
hold on;
for i = 1:length(pareto_save)
    front = pareto_save{i};
    plot(fitness_save(front, 1), fitness_save(front, 2), 'o', 'DisplayName', sprintf('Front %d', i));
end
hold off;
xlabel('Objective 1');
ylabel('Objective 2');
title('Pareto Fronts');
% legend('show');
