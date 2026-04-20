function delta = char_eq_compact(lambda, n, epsilon, params)
%CHAR_EQ_COMPACT Compact characteristic equation before denominator clearing.
%   This keeps the original integral representation from the paper:
%
%   Delta_n(lambda, epsilon)
%   = lambda + d1 * mu_n + d2 * u_bar * mu_n * H(lambda) - f_u,
%
%   where H(lambda) = integral_{-tau}^0 h(s) exp(lambda s) ds.
%
%   We keep this function only as a derivation/checking reference. The main
%   Hopf search code should use char_eq.m, which is the final formula used
%   in the paper after clearing lambda^2.

mu = mu_n(n, params.L);
kernel_value = kernel_integral(lambda, epsilon, params.tau);

delta = lambda ...
    + params.d1 * mu ...
    + params.d2 * params.u_bar * mu * kernel_value ...
    - params.f_u;
end
