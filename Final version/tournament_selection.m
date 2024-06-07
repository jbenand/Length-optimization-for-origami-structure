%------------- Find the best member of the selected members ----------------

% input: the selected population and their fitness
% ouput: the selected members of the population

function [best_individual] = tournament_selection(population, selection_size, front_membership, crowding_distances)

    possible_contestants = 1:length(front_membership);
    contestants = randsample(possible_contestants, selection_size);
    
    best_index = contestants(1);
    for i = 2:length(contestants)
        competitor_index = contestants(i);
        winner_index = crowding_operator(best_index, competitor_index, front_membership, crowding_distances);
    end

    best_individual = population(winner_index,:);

    % % Find the domination of each solution
    % [~, population_rank] = fast_nondominated_sort(population_fitness);
    % 
    % % Generate random indices
    % random_indices = randperm(length(population_rank));
    % 
    % % Select elements based on random indices
    % selected_population = population(random_indices,:);
    % selected_population = selected_population(1:1:selection_size,:);
    % random_rank = population_rank(random_indices);
    % random_rank = random_rank(1:1:selection_size);
    % % selected_fitness = population_fitness(random_indices);
    % 
    % % Apply tournament selection
    % [~, best_index] = min(random_rank);
    % best_individual = selected_population(best_index,:);
end