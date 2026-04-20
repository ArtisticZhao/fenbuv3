function value = S_fun(omega, epsilon, k, n, params)
%S_FUN Evaluate S_{n,k}(epsilon) along a chosen omega branch.
%   S_{n,k}(epsilon) = epsilon - (theta_n(epsilon) + 2*k*pi) / omega_n(epsilon)

theta = phase_theta(omega, epsilon, n, params);
value = epsilon - (theta + 2.0 * pi * k) ./ omega;
end
