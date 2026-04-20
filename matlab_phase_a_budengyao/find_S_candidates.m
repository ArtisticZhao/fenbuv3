function candidates = find_S_candidates(s_data, zero_tol)
%FIND_S_CANDIDATES Detect candidate critical values from S_{n,k}(epsilon)=0.
%   This stage reports numerical candidates based on sampled S-curves.
%   Exact refinement can be added later by solving a coupled system.

if nargin < 2
    zero_tol = 1.0e-3;
end

epsilon_grid = s_data.epsilon_grid(:);
omega_mat = s_data.omega_mat;
theta_mat = s_data.theta_mat;
S_tensor = s_data.S_tensor;
k_list = s_data.k_list;
num_branches = size(omega_mat, 2);
num_k = length(k_list);

candidates = struct( ...
    'n', {}, ...
    'branch_id', {}, ...
    'k', {}, ...
    'epsilon_star', {}, ...
    'omega_star', {}, ...
    'theta_star', {}, ...
    'method', {}, ...
    'left_index', {}, ...
    'right_index', {});

for k_idx = 1:num_k
    for branch_id = 1:num_branches
        S_curve = S_tensor(:, branch_id, k_idx);
        omega_curve = omega_mat(:, branch_id);
        theta_curve = theta_mat(:, branch_id);

        for idx = 1:(length(epsilon_grid) - 1)
            e1 = epsilon_grid(idx);
            e2 = epsilon_grid(idx + 1);
            S1 = S_curve(idx);
            S2 = S_curve(idx + 1);
            w1 = omega_curve(idx);
            w2 = omega_curve(idx + 1);
            t1 = theta_curve(idx);

            if isnan(S1) || isnan(S2) || isnan(w1) || isnan(w2)
                continue;
            end

            if abs(S1) <= zero_tol
                candidates(end + 1) = make_candidate( ... %#ok<AGROW>
                    s_data.n, branch_id, k_list(k_idx), e1, w1, t1, ...
                    'grid_hit', idx, idx);
                continue;
            end

            if S1 * S2 < 0
                ratio = -S1 / (S2 - S1);
                epsilon_star = e1 + ratio * (e2 - e1);
                omega_star = w1 + ratio * (w2 - w1);
                theta_star = mod(omega_star * epsilon_star, 2.0 * pi);

                candidates(end + 1) = make_candidate( ... %#ok<AGROW>
                    s_data.n, branch_id, k_list(k_idx), epsilon_star, ...
                    omega_star, theta_star, 'sign_change', idx, idx + 1);
            end
        end

        last_idx = length(epsilon_grid);
        if ~isnan(S_curve(last_idx)) && abs(S_curve(last_idx)) <= zero_tol ...
                && ~isnan(omega_curve(last_idx))
            candidates(end + 1) = make_candidate( ... %#ok<AGROW>
                s_data.n, branch_id, k_list(k_idx), epsilon_grid(last_idx), ...
                omega_curve(last_idx), theta_curve(last_idx), ...
                'grid_hit', last_idx, last_idx);
        end
    end
end
end

function candidate = make_candidate(n, branch_id, k, epsilon_star, omega_star, ...
    theta_star, method, left_index, right_index)
candidate = struct();
candidate.n = n;
candidate.branch_id = branch_id;
candidate.k = k;
candidate.epsilon_star = epsilon_star;
candidate.omega_star = omega_star;
candidate.theta_star = theta_star;
candidate.method = method;
candidate.left_index = left_index;
candidate.right_index = right_index;
end
