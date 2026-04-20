function residual = pure_imag_residual(omega, epsilon, n, params)
%PURE_IMAG_RESIDUAL Real-imag residual of char_eq(i * omega, epsilon) = 0.

lambda = 1i * omega;
if abs(lambda) < 1.0e-10
    delta = char_eq_compact(lambda, n, epsilon, params);
else
    delta = char_eq(lambda, n, epsilon, params);
end

residual = [real(delta); imag(delta)];
end
