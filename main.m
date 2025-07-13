clear; clc;
close all;
tic
%% ------------------  user-controlled parameters  ------------------
d1   = 0.1;        % diffusion coefficient for Laplacian  (d_1)
d2   = 2; % -2;         % coefficient in the non-local flux     (d_2)
r1   = 0.1 ; %0.1;        % logistic reaction factor             (f(u)=r1*u*(1-u))
tau  = 7.24;         % delay length  τ  (same symbol as in the paper)

L = pi/4;         % domain length so that Ω = [0, Ldom*π]



Nx   = 307;
dt   = 0.001;

Tend = 100;        % total simulation time

x = linspace(0, L, Nx);
dx = x(2) - x(1);

disp(dt/dx^2)
% assert(dt/dx^2<0.5)

Ns = round((2*tau) / dt);
Nt = round(Tend*tau/dt);

NT_tol = Ns + Nt;


s = (-2*tau:dt:0);
h = h_win(s, tau);

% figure;
% plot(s, h); title("h(s)")
% 
% u_test = rand(Nx, Nt);
% 
% u_tau = calc_u_tau(u_test, h, 0, dt);
% 
% res = laplacian_neumann(u_tau, dx)



%% ============== 初始条件设置 ==============
u0 = 1;                            % 基准稳态值 (初始均匀分布)
initial_perturbation = 0.01 * cos(6*pi*x/(L)); % 空间扰动项，满足x∈[0,Lπ]

figure;
plot(x, initial_perturbation+u0); title('init'); grid on;
% 初始数据矩阵：每列对应一个历史时刻，行对应空间点
u_history = repmat(u0 + initial_perturbation', 1, Ns+1); %将v0 + initial_perturbation作为元素，复制成Nx*K+1矩阵

u = [u_history zeros(Nx, Nt-1)];
assert(size(u, 2) == NT_tol);
u_tau_save = ones(size(u)) .* u0;
max_rhs = zeros(size(u, 2), 1);
flux_save = zeros(size(u));

flux_1_save = zeros(size(u));
flux_2_save = zeros(size(u));

for t = 1: Nt-1
    abs_idx = t + Ns;
    u_tau = calc_u_tau(u, h, t-1, dt);
    u_current = u(:, abs_idx); 
    u_tau_save(:, abs_idx) = u_tau;
    lap_u = laplacian_neumann(u_current, dx);
    if d2 ~= 0
        % flux = cross_diffusive_flux_4th_order(u_current, u_tau, dx);
        [flux, f1, f2] = cross_diffusive_flux_1(u_current, u_tau, dx);
    else
        flux = zeros(size(u_current));
    end
    f_u = r1*u_current.*(1-u_current); 

    flux_save(:, abs_idx) = flux;
    flux_1_save(:, abs_idx) = f1;
    flux_2_save(:, abs_idx) = f2;

    rhs = d1 * lap_u + d2 * flux + f_u;
    [~, max_idx] = max(abs(rhs));
    max_rhs(abs_idx) = rhs(max_idx);
    if (any(isnan(rhs)))
        warning('nan detected!');
        break;
    end
    u(:, abs_idx + 1) = u_current + rhs * dt;

    
end

toc

%============= 可视化 =============%
tax = -2*tau:dt:Tend*tau-dt;
[X, T_mesh] = meshgrid(x, tax);
% u(:, 60000:end) = 0.5;

cut_off = 0;
if cut_off > 0
u(:, tax>cut_off) = u0;
flux_save(:, tax>cut_off) = 0;
flux_1_save(:, tax>cut_off) = 0;
flux_2_save(:, tax>cut_off) = 0;
max_rhs( tax>cut_off) = 0;
u_tau_save(:, tax>cut_off) = u0;
end

figure;
surf(X, T_mesh, u.', 'EdgeColor', 'none');
view(2); 
colorbar;
clim([0, 2])
xlabel('x'); ylabel('t'); 
title('u(x,t)的时空演化');


figure;
sgtitle(sprintf(" cutoff: %d", cut_off));
tiledlayout(6, 1);
axx = [];

axx = [axx nexttile];
plot(tax, u.'); title('u')
grid on;

axx = [axx nexttile];
plot(tax, flux_save.'); title('flux')
grid on;

axx = [axx nexttile];
plot(tax, flux_1_save.'); title('flux part1')
grid on;

axx = [axx nexttile];
plot(tax, flux_2_save.'); title('flux part2')
grid on;



axx = [axx nexttile];
plot(tax, u_tau_save.'); title('u_{\tau}')
grid on;

axx = [axx nexttile];
plot(tax, max_rhs); title('max rhs'); grid on
linkaxes(axx, 'x')


 % xlim([0 81])