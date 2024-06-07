%------------- Generate offspring from selected individuals ----------------

% input: the selected population, the number of offspring
% ouput: the offspring population

function [offspring] = generate_offspring(population, selection_size, front_membership, crowding_distances, mutation_rate, min_r)
    offspring = zeros(length(population), 1);
    eta = 2;

    for i = 1:1:length(population)/2
        % select the parents
        parent_1 = tournament_selection(population, selection_size, front_membership, crowding_distances);
        parent_2 = tournament_selection(population, selection_size, front_membership, crowding_distances);

        % generate the offspring from the mean of the two parents
        offspring_1 = (parent_1+parent_2)/2;
        offspring_2 = abs((parent_1-parent_2)/2);
        %offspring_1 = zeros(size(parent_1));
        %offspring_2 = zeros(size(parent_2));
        if rand() < 0.1
            u = rand(); % Generate a random number between 0 and 1

            % Calculate beta value using polynomial distribution
            if u <= 0.5
                beta = (2 * u)^(1 / (eta + 1));
            else
                beta = (1 / (2 * (1 - u)))^(1 / (eta + 1));
            end

            % Save the values of the offsprings to compute the new ones
            offspring_save_1 = offspring_1;
            offspring_save_2 = offspring_2;

            % Calculate offspring values for each variable
            offspring_1 = offspring_save_1 + beta*offspring_save_2;
            offspring_2 = offspring_save_1 - beta*offspring_save_2;

        else 
            offspring_1 = parent_1;
            offspring_2 = parent_2;
        end
        
        % add random mutations to the offspring 
        if rand()<mutation_rate
            offspring_1 = offspring_1 + rand()*0.005;
        end
        if rand()<mutation_rate
            offspring_1 = offspring_1 + rand()*0.005;
        end

        if offspring_1(1) <= min_r
            offspring_1(1) = min_r;
        end
        if offspring_2(1) <= min_r
            offspring_2(1) = min_r;
        end

        offspring(i,:) = offspring_1;
        offspring(i+length(population)/2,:) = offspring_2;
    end
end