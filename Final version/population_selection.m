%------------- Select the best members of the population ----------------

% input: the population, their fitness and the number of members selected
% ouput: the selected members of the population

function [selected_population, selected_population_front_membership, selected_population_crowding_distance] = population_selection(population, population_fitness, pareto_fronts, population_size)
    % Select members of the best fronts for the new population and cut fronts
    % which exceed half of the population size.
    selected_population = {};
    selected_population_crowding_distance = [];
    selected_population_front_membership = [];
    
    num_fronts = 1;
    while length(selected_population) + length(pareto_fronts{num_fronts}) < population_size/2
        current_front = pareto_fronts{num_fronts};
    
        % Compute crowding distance for every front
        % crowding_distances = compute_crowding_distance(population_fitness, current_front);
        crowding_distances = new_crowding_distance(population_fitness, current_front);
    
        for front_index = 1:length(current_front)
            population_index = current_front(front_index);
            selected_population{end+1} = population(population_index);
            selected_population_front_membership(end+1) = num_fronts;
            selected_population_crowding_distance(end+1) = crowding_distances(front_index);
        end
    
        num_fronts = num_fronts + 1;
    end
    
    % Select the members with the highest crowding distances for the new population.
    num_open_slots = population_size/2 - length(selected_population);
    
    % Add crowding distance of splitted front
    % crowding_distances = compute_crowding_distance(population_fitness, pareto_fronts{num_fronts});
    crowding_distances = new_crowding_distance(population_fitness, pareto_fronts{num_fronts});
    [~, crowding_rank] = sort(crowding_distances, 'descend');
    
    for i = 1:num_open_slots
        candidate = crowding_rank(i);
        population_index = pareto_fronts{num_fronts}(candidate);
        selected_population{end+1} = population(population_index);
        selected_population_crowding_distance(end+1) = crowding_distances(candidate);
        selected_population_front_membership(end+1) = num_fronts;
    end
    
    % Convert to cell array
    selected_population = vertcat(selected_population{:});
end