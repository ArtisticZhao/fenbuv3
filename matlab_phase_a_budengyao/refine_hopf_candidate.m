function refined = refine_hopf_candidate(candidate, params, opts)
%REFINE_HOPF_CANDIDATE Refine a Phase C candidate by solving a 2D residual.
%   We avoid toolbox-dependent solvers and use fminsearch on the squared
%   residual norm with a soft penalty for leaving the admissible domain.
%   Refinement is performed on the branch-search system itself:
%   G(omega, epsilon) = 0 and S_{n,k}(epsilon) = 0.

if nargin < 3 || isempty(opts)
    opts = make_phase_d_options();
end

initial = [candidate.omega_star, candidate.epsilon_star];
objective = @(vec) penalized_objective(vec, candidate.n, candidate.k, params, opts);
[vector_opt, objective_value, exitflag] = ...
    fminsearch(objective, initial, opts.fminsearch_options);

omega = vector_opt(1);
epsilon = vector_opt(2);

theta = phase_theta(omega, epsilon, candidate.n, params);
g_value = G_fun(omega, epsilon, candidate.n, params);
s_value = S_fun(omega, epsilon, candidate.k, candidate.n, params);
residual_vec = [g_value; s_value];
residual_norm = norm(residual_vec, 2);
k_est = candidate.k;

refined = candidate;
refined.omega_refined = omega;
refined.epsilon_refined = epsilon;
refined.theta_refined = theta;
refined.k_est = k_est;
refined.objective_value = objective_value;
refined.exitflag = exitflag;
refined.g_value = g_value;
refined.s_value = s_value;
refined.residual_real = residual_vec(1);
refined.residual_imag = residual_vec(2);
refined.residual_norm = residual_norm;
refined.is_admissible = (omega > opts.omega_floor) ...
    && (epsilon > 0) ...
    && (epsilon < params.tau);
refined.is_refined = refined.is_admissible && (residual_norm <= opts.refine_tol);
end

function value = penalized_objective(vec, n, k, params, opts)
omega = vec(1);
epsilon = vec(2);

penalty = 0.0;
if omega <= opts.omega_floor
    penalty = penalty + (opts.omega_floor + 1.0 - omega)^2;
end
if epsilon <= 0
    penalty = penalty + (1.0 - epsilon)^2;
elseif epsilon >= params.tau
    penalty = penalty + (epsilon - params.tau + 1.0)^2;
end

if penalty > 0
    value = 1.0e6 * penalty;
    return;
end

g_value = G_fun(omega, epsilon, n, params);
s_value = S_fun(omega, epsilon, k, n, params);
value = g_value^2 + s_value^2;
end
