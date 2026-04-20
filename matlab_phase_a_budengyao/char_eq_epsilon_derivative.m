function derivative = char_eq_epsilon_derivative(lambda, n, epsilon, params)
%CHAR_EQ_EPSILON_DERIVATIVE Partial derivative d/depsilon of char_eq.

mu = mu_n(n, params.L);
amplitude = 2.0 * params.d2 * params.u_bar * mu;

dp0 = amplitude / (params.tau * (params.tau - epsilon)^2);
dp1 = -amplitude / (params.tau * epsilon^2);
dp2 = amplitude * (params.tau - 2.0 * epsilon) ...
    / (epsilon^2 * (params.tau - epsilon)^2);
p2 = -amplitude / (epsilon * (params.tau - epsilon));

derivative = dp0 ...
    + dp1 * exp(-lambda * params.tau) ...
    + dp2 * exp(-lambda * epsilon) ...
    - lambda * p2 * exp(-lambda * epsilon);
end
