%------------- Crowding operator ----------------

% input: individual index, other individual index, population rank,
% crowding distances
% ouput: index of the better individual

function selected_index = crowding_operator(individual_index, other_individual_index, population_rank, crowding_distances)
    if population_rank(individual_index) < population_rank(other_individual_index)
        selected_index = individual_index;
    elseif crowding_distances(individual_index) >= crowding_distances(other_individual_index)
        selected_index = individual_index;
    else
        selected_index = other_individual_index;
    end
end