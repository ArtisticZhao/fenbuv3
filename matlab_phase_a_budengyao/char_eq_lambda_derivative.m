function derivative = char_eq_lambda_derivative(lambda, n, epsilon, params)
%CHAR_EQ_LAMBDA_DERIVATIVE Partial derivative d/dlambda of char_eq.

mu = mu_n(n, params.L);
drift = params.d1 * mu - params.f_u;
amplitude = 2.0 * params.d2 * params.u_bar * mu;

p1 = amplitude / (params.tau * epsilon);
p2 = -amplitude / (epsilon * (params.tau - epsilon));

derivative = 3.0 * lambda.^2 ...
    + 2.0 * drift * lambda ...
    - params.tau * p1 * exp(-lambda * params.tau) ...
    - epsilon * p2 * exp(-lambda * epsilon);
end
