function delta = char_eq(lambda, n, epsilon, params)
%CHAR_EQ Final characteristic equation used in the Hopf workflow.
%   For the Hopf analysis we only need nonzero purely imaginary roots
%   lambda = i * omega with omega > 0. In that regime, the paper rewrites
%   the characteristic equation into the polynomial-exponential form
%
%   P0(lambda) + P1 * exp(-lambda * tau) + P2 * exp(-lambda * epsilon) = 0,
%
%   which is the final formula we will carry into Phase B.

mu = mu_n(n, params.L);
tol = 1.0e-10;

if abs(lambda) < tol
    error('char_eq:ZeroLambda', ...
        ['The final exponential form is intended for lambda ~= 0. ', ...
         'Use char_eq_compact for the lambda = 0 limit if needed.']);
end

p0 = lambda.^3 ...
    + (params.d1 * mu - params.f_u) * lambda.^2 ...
    + 2.0 * params.d2 * params.u_bar * mu / (params.tau * (params.tau - epsilon));
p1 = 2.0 * params.d2 * params.u_bar * mu / (params.tau * epsilon);
p2 = -2.0 * params.d2 * params.u_bar * mu / (epsilon * (params.tau - epsilon));

delta = p0 + p1 * exp(-lambda * params.tau) + p2 * exp(-lambda * epsilon);
end
