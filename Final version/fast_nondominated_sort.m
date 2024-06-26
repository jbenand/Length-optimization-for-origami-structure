%------------- Find the pareto fronts ----------------

% input: population fitness
% ouput: pareto fronts, rank of each individual

function [pareto_fronts, population_rank] = fast_nondominated_sort(fitness)
    num_individuals = length(fitness);

    domination_lists = cell(1, num_individuals);
    pareto_fronts = {};
    domination_counts = zeros(1, num_individuals);
    population_rank = zeros(1, num_individuals);

    for individual_a = 1:num_individuals
        domination_lists{individual_a} = [];
        
        for individual_b = 1:num_individuals
            % Does individual a dominate individual b
            if dominates(fitness(individual_a), fitness(individual_b))
                domination_lists{individual_a} = [domination_lists{individual_a}, individual_b];

            % Does individual b dominate individual a
            elseif dominates(fitness(individual_b), fitness(individual_a))
                domination_counts(individual_a) = domination_counts(individual_a) + 1;
            end
        end

        if domination_counts(individual_a) == 0
            population_rank(individual_a) = 1;
            if isempty(pareto_fronts)
                pareto_fronts{1} = individual_a;
            else
                pareto_fronts{1} = [pareto_fronts{1}, individual_a];
            end
        end
    end

    i = 1;
    while ~isempty(pareto_fronts{i})
        next_front = [];
        for j = pareto_fronts{i}
            for k = domination_lists{j}
                domination_counts(k) = domination_counts(k) - 1;
                if domination_counts(k) == 0
                    population_rank(k) = i + 1;
                    next_front = [next_front, k];
                end
            end
        end
        i = i + 1;
        pareto_fronts{i} = next_front;
    end

    pareto_fronts = pareto_fronts(1:end-1);
end