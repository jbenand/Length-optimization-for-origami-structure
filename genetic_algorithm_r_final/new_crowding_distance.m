%------------- Compute crowding distance ----------------

% input: population_fitness, pareto front
% ouput: distance of the solutions in the obejctive space

function distance = new_crowding_distance(fitness, front)

    distance = zeros(1, length(front));

    normalized_fitness = fitness;

    scale_1 = max(fitness(:,1))-min(fitness(:,1));
    scale_2 = max(fitness(:,2))-min(fitness(:,2));

    if scale_1 == 0
        scale_1 = 1;
    end
    if scale_2 == 0
        scale_2 = 1;
    end

    normalized_fitness(:,1) = (fitness(:,1)-min(fitness(:,1)))/scale_1;
    normalized_fitness(:,2) = (fitness(:,2)-min(fitness(:,2)))/scale_2;

    for i = 1:length(front)
        element = normalized_fitness(front(i),:);

        normalized_fitness = normalized_fitness - element;
        normalized_fitness = normalized_fitness.^2;
        
        for j = 1:length(fitness)
            distance(i) = distance(i) + normalized_fitness(j);
        end
    end
end