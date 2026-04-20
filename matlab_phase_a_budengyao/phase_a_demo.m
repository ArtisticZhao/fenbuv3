function phase_a_demo()
%PHASE_A_DEMO Minimal demonstration for the Phase A formula layer.
%   This script does not search Hopf points yet. It only evaluates the
%   characteristic equation for one mode and one sample lambda value.

params = make_budengyao_params();

n = 1;
epsilon = 0.6;
lambda = 1i * 1.25;

mu = mu_n(n, params.L);
kernel_value = kernel_integral(lambda, epsilon, params.tau);
delta_final = char_eq(lambda, n, epsilon, params);
delta_compact = char_eq_compact(lambda, n, epsilon, params);

fprintf('Phase A demo for budengyao Hopf analysis\n');
fprintf('  n = %d\n', n);
fprintf('  mu_n = %.10f\n', mu);
fprintf('  epsilon = %.10f\n', epsilon);
fprintf('  lambda = %.10f %+.10fi\n', real(lambda), imag(lambda));
fprintf('  H(lambda) = %.10f %+.10fi\n', real(kernel_value), imag(kernel_value));
fprintf('  Final characteristic equation value = %.10f %+.10fi\n', ...
    real(delta_final), imag(delta_final));
fprintf('  Compact equation value = %.10f %+.10fi\n', ...
    real(delta_compact), imag(delta_compact));
fprintf('  Consistency gap = %.3e\n', abs(delta_final - lambda.^2 .* delta_compact));
end
