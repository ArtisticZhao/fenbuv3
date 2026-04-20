function val = sin_rhs(omega, epsilon, n, params)
%SIN_RHS Right-hand side of the sine equation in budengyao.pdf (0.8).

mu = mu_n(n, params.L);
coupling = 2.0 * params.d2 * params.u_bar * mu;

val = epsilon * (params.tau - epsilon) .* omega.^3 ./ coupling ...
    + (epsilon / params.tau) .* sin(omega .* params.tau);
end
