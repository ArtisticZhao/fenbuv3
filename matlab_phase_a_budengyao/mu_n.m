function mu = mu_n(n, L)
%MU_N Neumann Laplacian eigenvalue on the interval (0, L).
%   For the cosine mode cos(n * pi * x / L), the eigenvalue is
%   mu_n = (n * pi / L)^2.

mu = (n * pi / L) .^ 2;
end
