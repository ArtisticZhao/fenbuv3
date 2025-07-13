function div = cross_diffusive_flux_4th_order(u, u_tau, dx)

dutaudx = calculate_derivative_4th_order(u_tau, dx);
u_dutaudx = u.*dutaudx;
div = calculate_derivative_4th_order(u_dutaudx, dx);

end