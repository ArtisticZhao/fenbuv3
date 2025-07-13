function div = cross_diffusive_flux(u, u_tau, dx)
% CROSS_DIFFUSIVE_FLUX  Conservative 2-nd-order scheme for ∂x( u ∂x u_tau )
%                       on a 1-D uniform grid with homogeneous Neumann BCs.
%
%   div = CROSS_DIFFUSIVE_FLUX(u, u_tau, dx)
%
%   Inputs
%   ------
%   u     : vector (N+1)   – present-time field at grid nodes 0 … N
%   u_tau : vector (N+1)   – delayed field      at grid nodes 0 … N
%   dx    : scalar         – uniform grid spacing
%
%   Output
%   -------
%   div   : vector (N+1)   – discrete divergence at grid nodes 0 … N
%
%   Discretisation
%   --------------
%   1. Extend both fields with one mirror ghost cell on each side
%      to impose zero-gradient (Neumann) boundary conditions.
%   2. Compute face-centred gradients of u_tau and averages of u.
%   3. Evaluate flux = u_face .* (∂x u_tau)_face at all faces.
%   4. Take the discrete divergence back to cell centres / nodes.
%
%   The routine is orientation-agnostic (row or column vectors accepted).

    % ---------  Input checks  ------------------------------------------------
    assert(isvector(u) && isvector(u_tau), ...
        'u and u_tau must be 1-D vectors of equal length.');
    assert(numel(u) == numel(u_tau), 'u and u_tau lengths differ.');
    assert(isscalar(dx) && dx > 0, 'dx must be a positive scalar.');

    N  = numel(u) - 1;          % number of intervals
    sz = size(u);               % preserve row/column orientation

    % --------- 1. Ghost-cell extension  --------------------------------------
    ug      = zeros(N + 3, 1);
    utaug   = zeros(N + 3, 1);

    ug(2:N+2)     = u(:).';         % interior nodes
    utaug(2:N+2)  = u_tau(:).';

    % mirror ghosts (zero gradient)
    ug(1)         = ug(3);          % left ghost
    ug(end)       = ug(end-2);      % right ghost
    utaug(1)      = utaug(3);
    utaug(end)    = utaug(end-2);

    % --------- 2. Face-centred quantities  -----------------------------------
    grad_face = (utaug(2:end) - utaug(1:end-1)) / dx;      % length N+2
    u_face    = 0.5 * (ug(1:end-1) + ug(2:end));           % length N+2
    % u_face = spline((-1:length(ug)-2).', ug, (-1:length(ug)-3).'+0.5);

    % --------- 3. Flux at faces  ---------------------------------------------
    flux_face = u_face .* grad_face;                       % length N+2
    flux_face(1) = 0;
    flux_face(end) = 0;

    % --------- 4. Divergence at nodes  ---------------------------------------
    div = (flux_face(2:end) - flux_face(1:end-1)) / dx;    % length N+1

    % Restore original orientation (row ↔ column)
    div = reshape(div, sz);

    div(1) = div(2);
    div(end) = div(end-1);
end