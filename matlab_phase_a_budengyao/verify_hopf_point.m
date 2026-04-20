function verified = verify_hopf_point(refined, params, opts)
%VERIFY_HOPF_POINT Check residual, simple-root, and transversality criteria.

if nargin < 3 || isempty(opts)
    opts = make_phase_d_options();
end

verified = refined;
if ~refined.is_admissible
    verified.delta_value = NaN;
    verified.delta_lambda = NaN;
    verified.delta_epsilon = NaN;
    verified.dlambda_depsilon = NaN;
    verified.is_g_root = false;
    verified.is_s_root = false;
    verified.is_small_residual = false;
    verified.is_simple_root = false;
    verified.is_transversal = false;
    verified.is_hopf_point = false;
    return;
end

lambda = 1i * refined.omega_refined;
delta = char_eq(lambda, refined.n, refined.epsilon_refined, params);
delta_lambda = char_eq_lambda_derivative(lambda, refined.n, ...
    refined.epsilon_refined, params);
delta_epsilon = char_eq_epsilon_derivative(lambda, refined.n, ...
    refined.epsilon_refined, params);
dlambda_depsilon = -delta_epsilon / delta_lambda;

verified.delta_value = delta;
verified.delta_lambda = delta_lambda;
verified.delta_epsilon = delta_epsilon;
verified.dlambda_depsilon = dlambda_depsilon;
verified.is_g_root = abs(refined.g_value) <= opts.g_tol;
verified.is_s_root = abs(refined.s_value) <= opts.s_tol;
verified.is_small_residual = abs(delta) <= opts.refine_tol;
verified.is_simple_root = abs(delta_lambda) > opts.simple_root_tol;
verified.is_transversal = abs(real(dlambda_depsilon)) > opts.transversality_tol;
verified.is_hopf_point = verified.is_refined ...
    && verified.is_g_root ...
    && verified.is_s_root ...
    && verified.is_small_residual ...
    && verified.is_simple_root ...
    && verified.is_transversal;
end
