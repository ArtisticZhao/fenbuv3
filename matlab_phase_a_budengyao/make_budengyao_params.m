function params = make_budengyao_params()
%MAKE_BUDENGYAO_PARAMS Default parameters for the Budengyao Hopf workflow.
%   The defaults follow the same conventions as the Python branch-search
%   script already stored in this repository.

params = struct();
params.d1 = 0.3;
params.d2 = 1.5;
params.r1 = 0.1;
params.u_bar = 1.0;
params.tau = 2.0;
params.L = pi;

% For f(u) = r1 * u * (1 - u), the positive equilibrium is u_bar = 1 and
% f'(u_bar) = -r1.
params.f_u = -params.r1;
end
