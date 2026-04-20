function H = kernel_integral(lambda, epsilon, tau)
%KERNEL_INTEGRAL Closed-form transform of the Budengyao delay kernel.
%   H(lambda) = integral_{-tau}^0 h(s) exp(lambda s) ds
%   for the asymmetric piecewise kernel h(s) used in budengyao.pdf.

validateattributes(epsilon, {'numeric'}, {'real', 'scalar', 'positive'});
validateattributes(tau, {'numeric'}, {'real', 'scalar', 'positive'});

if ~(epsilon < tau)
    error('kernel_integral:InvalidEpsilon', ...
        'epsilon must satisfy 0 < epsilon < tau.');
end

tol = 1.0e-10;

if abs(lambda) < tol
    H = 1.0;
    return;
end

numerator = 2.0 * ( ...
    tau - epsilon + epsilon * exp(-lambda * tau) - tau * exp(-lambda * epsilon));
denominator = tau * epsilon * (tau - epsilon) * lambda.^2;
H = numerator ./ denominator;
end
