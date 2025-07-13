function lap = laplacian_neumann(u, dx)
% LAPLACIAN_NEUMANN  Discrete 1-D Laplacian with homogeneous Neumann BCs.
%
%   lap = LAPLACIAN_NEUMANN(u, dx) returns the second-derivative of a
%   one-dimensional field stored at grid nodes, enforcing zero-gradient
%   (Neumann) boundary conditions at both ends by ghost-cell reflection.
%
%   Inputs
%   ------
%   u   : vector (N+1)   – field values at grid nodes
%   dx  : scalar         – uniform grid spacing
%
%   Output
%   ------
%   lap : vector (N+1)   – discrete Laplacian at each node
%
%   Scheme
%   ------
%   • Interior nodes:      (u_{i-1} − 2u_i + u_{i+1}) / dx²      (2nd-order)
%   • Boundary nodes:      2(u_1 − u_0) / dx²  and  2(u_{N-1} − u_N) / dx²
%                          (obtained via mirror ghosts to impose ∂x u = 0)
%
%   The function is orientation-agnostic: row- and column-vectors are both
%   supported.

  %   % Validate inputs
  %   assert(isvector(u), 'u must be a 1-D vector.');
  %   assert(isscalar(dx) && dx > 0, 'dx must be a positive scalar.');
  % 
  %   lap = zeros(size(u));
  % 
  %   % Interior nodes (indices 2 … N)
  %   lap(2:end-1) = (u(1:end-2) - 2*u(2:end-1) + u(3:end)) / dx^2;
  % 
  %   % % Neumann boundaries (mirror ghost cells)
  %   % lap(1)      = 2 * (u(2)      - u(1))      / dx^2;
  %   % lap(end)    = 2 * (u(end-1)  - u(end))    / dx^2;
  % 
  % % -------------- fourth-order boundaries ------------------------------
  %   % Left boundary  i = 1  (node x = 0)
  %   lap(1) = (-u(3) + 16*u(2) - 15*u(1)) / (6*dx^2);
  % 
  %   % Right boundary i = N+1 (node x = L)
  %   lap(end) = (-u(end-2) + 16*u(end-1) - 15*u(end)) / (6*dx^2);
  %   % lap(1) = lap(2);
  %   % lap(end) = lap(end-1);



    % Fourth-order discrete Laplacian with Neumann boundary conditions
    assert(isvector(u), 'u must be a 1-D vector.');
    assert(isscalar(dx) && dx > 0, 'dx must be a positive scalar.');

    lap = zeros(size(u));

    % Interior points (i = 3 to N-1)
    lap(3:end-2) = (-u(5:end) + 16*u(4:end-1) - 30*u(3:end-2) + 16*u(2:end-3) - u(1:end-4)) / (12 * dx^2);

    % Near-boundary points: use second-order (or you could try asymmetric 4th order)
    lap(2) = (u(1) - 2*u(2) + u(3)) / dx^2;
    lap(end-1) = (u(end-2) - 2*u(end-1) + u(end)) / dx^2;

    % Neumann boundaries: mirror approach, second-order
    lap(1) = 2 * (u(2) - u(1)) / dx^2;
    lap(end) = 2 * (u(end-1) - u(end)) / dx^2;
end