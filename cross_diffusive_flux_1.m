function [div, dudv, u_lap_utau] = cross_diffusive_flux_1(u, u_tau, dx)
% 
% assert(isequal(size(u), size(u_tau)), 'u and u_tau must in same size!');
% 
% dudv = zeros(size(u));
% 
% dudv(2:end-1) = ((u(3:end) - u(1:end-2)) .* (u_tau(3:end) - u_tau(1:end-2))) ./ (4*dx.^2);
% 
% % div(1) = ((u(1) - u(2)) .* (u_tau(1) - u_tau(2))) ./ (4*dx.^2);
% % div(end-1) = ((u(end-1) - u(end)) .* (u_tau(end-1) - u_tau(end))) ./ (4*dx.^2);
% dudv(1) = 0;
% dudv(end-1) = 0;
% 
% 
% 
% u_lap_utau = u.*laplacian_neumann(u_tau, dx);
% div = dudv + u_lap_utau;


assert(isequal(size(u), size(u_tau)), 'u and u_tau must in same size!');

dudv = zeros(size(u));

% Four-order gradients for u and u_tau
grad_u = zeros(size(u));
grad_utau = zeros(size(u_tau));

% Interior points: i = 3 to N-1
grad_u(3:end-2) = (-u(5:end) + 8*u(4:end-1) - 8*u(2:end-3) + u(1:end-4)) / (12 * dx);
grad_utau(3:end-2) = (-u_tau(5:end) + 8*u_tau(4:end-1) - 8*u_tau(2:end-3) + u_tau(1:end-4)) / (12 * dx);

% dudv: gradient product
dudv(3:end-2) = grad_u(3:end-2) .* grad_utau(3:end-2);

% Boundary points: set to 0 or low-order scheme
dudv(1:2) = 0;
dudv(end-1:end) = 0;

% Laplacian part
u_lap_utau = u .* laplacian_neumann(u_tau, dx);

% Final sum
div = dudv + u_lap_utau;

end