%------------- Compute crowding distance ----------------

% input: population_fitness, pareto front
% ouput: distance of the solutions in the obejctive space

function distance = compute_crowding_distance(fitness, front)

    num_objectives = size(fitness, 2);
    distance = zeros(1, length(front));

    for i = 1:num_objectives
        front_fitness = fitness(front, i);
        [~, sorted_indices] = sort(front_fitness);
        
        max_f = max(front_fitness);
        min_f = min(front_fitness);
        
        distance(sorted_indices(1)) = Inf;
        distance(sorted_indices(end)) = Inf;

        scale = max_f - min_f;
        % secure edge case
        if scale == 0
            scale = 1;
        end
            
        for j = 2:length(front) - 1
            distance(sorted_indices(j)) = distance(sorted_indices(j)) + ...
                (front_fitness(sorted_indices(j + 1)) - front_fitness(sorted_indices(j - 1))) / scale;
        end
    end
end