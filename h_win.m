function [h] = h_win(s, tau)
%H_WIN Summary of this function goes here
%   Detailed explanation goes here
h = zeros(1, length(s));

for i=1:length(s)

    if -2*tau <= s(i) && s(i) <= -tau
        h(i) = 1/(tau.^2) * s(i) + 2 / tau;
    else
        h(i) = -1/(tau.^2) * s(i);
    end
end

end

