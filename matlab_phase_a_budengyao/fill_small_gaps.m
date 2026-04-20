function omega_mat = fill_small_gaps(omega_mat, max_gap)
%FILL_SMALL_GAPS Linearly fill short NaN gaps inside one omega branch.

num_branches = size(omega_mat, 2);

for branch_id = 1:num_branches
    branch = omega_mat(:, branch_id);
    valid_idx = find(~isnan(branch));

    if numel(valid_idx) < 2
        continue;
    end

    for pos = 1:(numel(valid_idx) - 1)
        left = valid_idx(pos);
        right = valid_idx(pos + 1);
        gap = right - left - 1;

        if gap <= 0 || gap > max_gap
            continue;
        end

        values = linspace(branch(left), branch(right), gap + 2);
        branch((left + 1):(right - 1)) = values(2:(end - 1));
    end

    omega_mat(:, branch_id) = branch;
end
end
