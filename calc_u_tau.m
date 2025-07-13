function [u_tau] = calc_u_tau(u, h, t, dt)
%CALC_U_TAU Summary of this function goes here
%   Detailed explanation goes here

t_idx_abs = t;
t_idx = t_idx_abs + length(h) - 1;

% u_seg = u(:, 1+(t_idx_abs:t_idx));
% 
% u_tau = u_seg .* repmat(h, size(u, 1), 1);
% 
% u_tau = sum(u_tau, 2) .* dt;

u_tau = u(:, 1+(t_idx_abs:t_idx))*h(:).* dt;

end

