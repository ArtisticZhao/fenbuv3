function unique_points = deduplicate_hopf_points(points, epsilon_tol, omega_tol)
%DEDUPLICATE_HOPF_POINTS Remove repeated refined points from nearby samples.

if nargin < 2
    epsilon_tol = 1.0e-5;
end
if nargin < 3
    omega_tol = 1.0e-5;
end

if isempty(points)
    unique_points = points;
    return;
end

keys = [[points.n].', [points.k_est].', [points.epsilon_refined].', [points.omega_refined].'];
[~, order] = sortrows(keys, [1, 2, 3, 4]);
points = points(order);

keep = true(size(points));
for idx = 2:numel(points)
    prev = points(idx - 1);
    curr = points(idx);

    same_mode = prev.n == curr.n;
    same_k = prev.k_est == curr.k_est;
    close_epsilon = abs(prev.epsilon_refined - curr.epsilon_refined) <= epsilon_tol;
    close_omega = abs(prev.omega_refined - curr.omega_refined) <= omega_tol;

    if same_mode && same_k && close_epsilon && close_omega
        keep(idx) = false;
    end
end

unique_points = points(keep);
end
