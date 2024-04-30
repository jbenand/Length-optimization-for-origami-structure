%------------- Initialize the population for GA ----------------

% input: the population size
% ouput: the initial population

function [population] = initialize_population(population_size, r_min, r_max)
    % initialize a population with random r values in the range
    population = zeros(population_size, 1);
    for i=1:1:population_size
        population(i,1) = (r_max - r_min) * rand() + r_min;
    end
end
