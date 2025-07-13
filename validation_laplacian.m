% -------------------------------------------------------------------------
% VERIFY_LAPLACIAN_NEUMANN.M
% -------------------------------------------------------------------------
% Numerical convergence test for laplacian_neumann.m
%
% The analytical test function u(x)=cos(k*pi*x/L) satisfies homogeneous
% Neumann BCs on [0,L].  We compare the discrete Laplacian against the
% exact second derivative and measure the L2-error for a sequence of grids.

clear;  clc;
close all

% ---- configuration ------------------------------------------------------
L   = 1.0;                % domain length
k   = 4;                  % mode number (try 1,2,3,…)
f_str = 'cos(k\pix/L)';
f   = @(x) cos(k*pi*x/L);                 % test function
fxx = @(x) -(k*pi/L)^2 * cos(k*pi*x/L);   % exact second derivative

% f_str = 'sin(k\pix/L)';
% f   = @(x) sin(k*pi*x/L);                 % test function
% fxx = @(x) -(k*pi/L)^2 * sin(k*pi*x/L);   % exact second derivative

Nvec = 20 * 2.^(0:4);     % number of intervals to test (20,40,80,160,320)

fprintf('  N    dx          L2-error        rate\n');
fprintf('---- -------- ----------------  --------\n');

prevErr = NaN;
figure;
sgtitle(sprintf('laplacian validation'))
tiledlayout(5,1);
for N = Nvec
    dx = L / N;                   % uniform spacing
    x  = linspace(0, L, N+1);     % N+1 nodes (including both ends)

    u        = f(x);
    lapExact = fxx(x);
    lapNum   = laplacian_neumann(u, dx);

    % L2 error (sqrt(dx) scales the discrete 2-norm to an integral norm)
    err = norm(lapNum - lapExact, 2) * sqrt(dx);

    % estimated order of accuracy
    if isnan(prevErr)
        rate = NaN;
    else
        rate = log(prevErr / err) / log(2);
    end
    prevErr = err;

    fprintf('%4d %8.3e %16.6e  %8.3f\n', N, dx, err, rate);
    nexttile;
    plot(x, lapExact, 'r-'); hold on;
    plot(x, lapNum, 'b--')
    title(sprintf('%s, dx=%e, N=%d', f_str, dx, N))
end