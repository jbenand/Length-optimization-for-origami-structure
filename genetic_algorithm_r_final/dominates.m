%------------- Does a solution dominate another one ----------------

% input: fitness of an individual, fitness of another individual
% ouput: if a the first individual dominates the second one

function [result] = dominates(fitness_individual, fitness_other_individual)
    and_condition = true;
    or_condition = false;

    for i = 1:length(fitness_individual)
        first = fitness_individual(i);
        second = fitness_other_individual(i);
        and_condition = and_condition && (first >= second);
        or_condition = or_condition || (first > second);
    end

    result = and_condition && or_condition;
end