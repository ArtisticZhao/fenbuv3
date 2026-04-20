function val = cos_rhs(omega, epsilon, n, params)
%COS_RHS Right-hand side of the cosine equation in budengyao.pdf (0.9).

mu = mu_n(n, params.L);
drift = params.d1 * mu - params.f_u;
coupling = 2.0 * params.d2 * params.u_bar * mu;

val = (params.tau - epsilon) / params.tau ...
    + (epsilon / params.tau) .* cos(omega .* params.tau) ...
    - epsilon * (params.tau - epsilon) * drift .* omega.^2 ./ coupling;
end
