function s_data = compute_S_branches(branch_data, k_list, params)
%COMPUTE_S_BRANCHES Compute theta and S_{n,k} along each omega branch.

epsilon_grid = branch_data.epsilon_grid(:);
omega_mat = branch_data.omega_mat;
num_eps = length(epsilon_grid);
num_branches = size(omega_mat, 2);
num_k = length(k_list);

theta_mat = nan(num_eps, num_branches);
S_tensor = nan(num_eps, num_branches, num_k);

for branch_id = 1:num_branches
    for idx = 1:num_eps
        omega = omega_mat(idx, branch_id);
        if isnan(omega)
            continue;
        end

        epsilon = epsilon_grid(idx);
        theta_mat(idx, branch_id) = phase_theta(omega, epsilon, branch_data.n, params);

        for k_idx = 1:num_k
            S_tensor(idx, branch_id, k_idx) = ...
                epsilon - (theta_mat(idx, branch_id) + 2.0 * pi * k_list(k_idx)) / omega;
        end
    end
end

s_data = struct();
s_data.n = branch_data.n;
s_data.mu = branch_data.mu;
s_data.epsilon_grid = branch_data.epsilon_grid;
s_data.omega_mat = omega_mat;
s_data.theta_mat = theta_mat;
s_data.k_list = k_list;
s_data.S_tensor = S_tensor;
end
