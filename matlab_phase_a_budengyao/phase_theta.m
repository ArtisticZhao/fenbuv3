function theta = phase_theta(omega, epsilon, n, params)
%PHASE_THETA Recover theta_n(epsilon) from the sine/cosine pair.
%   The paper defines theta_n(epsilon) in [0, 2*pi) through
%   cos(theta) = cos(omega * epsilon), sin(theta) = sin(omega * epsilon).
%   Numerically we recover the same phase via atan2 applied to the right-
%   hand sides of equations (0.8) and (0.9).

s = sin_rhs(omega, epsilon, n, params);
c = cos_rhs(omega, epsilon, n, params);

theta = atan2(s, c);
theta = mod(theta, 2.0 * pi);
end
