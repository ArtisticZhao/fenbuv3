function omega_mat = assign_root_branches(roots_cell, opts)
%ASSIGN_ROOT_BRANCHES Connect root clouds into approximate omega branches.
%   Each epsilon slice may contain several positive roots. This routine
%   matches roots across neighboring epsilon slices by continuity.

num_eps = length(roots_cell);
omega_mat = nan(num_eps, opts.max_branches);
last_omega = nan(1, opts.max_branches);
num_active = 0;

for idx = 1:num_eps
    roots = roots_cell{idx};
    if isempty(roots)
        continue;
    end

    roots = roots(:).';
    is_used = false(size(roots));

    if num_active > 0
        active_values = last_omega(1:num_active);
        active_ids = find(~isnan(active_values));

        if ~isempty(active_ids)
            active_values = active_values(active_ids).';
            distance = abs(active_values - roots);
            threshold = max(opts.branch_gap_abs, opts.branch_gap_rel * active_values);
            distance(distance > threshold) = Inf;

            while true
                [min_value, linear_idx] = min(distance(:));
                if isinf(min_value)
                    break;
                end

                [branch_pos, root_pos] = ind2sub(size(distance), linear_idx);
                branch_id = active_ids(branch_pos);
                omega_mat(idx, branch_id) = roots(root_pos);
                last_omega(branch_id) = roots(root_pos);
                is_used(root_pos) = true;
                distance(branch_pos, :) = Inf;
                distance(:, root_pos) = Inf;
            end
        end
    end

    for root_pos = find(~is_used)
        if num_active >= opts.max_branches
            break;
        end

        num_active = num_active + 1;
        omega_mat(idx, num_active) = roots(root_pos);
        last_omega(num_active) = roots(root_pos);
    end
end

keep = any(~isnan(omega_mat), 1);
omega_mat = omega_mat(:, keep);
end
