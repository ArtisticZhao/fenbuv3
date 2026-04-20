function roots = find_omega_roots(epsilon, n, params, opts)
%FIND_OMEGA_ROOTS Find positive roots of G(omega, epsilon) = 0.

if nargin < 4 || isempty(opts)
    opts = make_phase_b_options();
end

omega_grid = linspace(opts.omega_min, opts.omega_max, opts.num_omega);
values = G_fun(omega_grid, epsilon, n, params);

roots = [];
for idx = 1:(length(omega_grid) - 1)
    left = omega_grid(idx);
    right = omega_grid(idx + 1);
    value_left = values(idx);
    value_right = values(idx + 1);

    if isnan(value_left) || isnan(value_right) || isinf(value_left) || isinf(value_right)
        continue;
    end

    candidate = NaN;

    if abs(value_left) < opts.root_tol
        candidate = left;
    elseif value_left * value_right < 0
        try
            candidate = fzero(@(omega) G_fun(omega, epsilon, n, params), [left, right]);
        catch
            candidate = NaN;
        end
    end

    if isnan(candidate)
        continue;
    end

    if candidate <= 0
        continue;
    end

    if isempty(roots) || all(abs(roots - candidate) > opts.dup_tol)
        roots(end + 1) = candidate; %#ok<AGROW>
        if length(roots) >= opts.max_roots
            break;
        end
    end
end

roots = sort(roots);
end
