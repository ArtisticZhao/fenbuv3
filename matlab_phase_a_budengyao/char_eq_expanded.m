function delta = char_eq_expanded(lambda, n, epsilon, params)
%CHAR_EQ_EXPANDED Backward-compatible wrapper for the final formula.
%   This name is retained so earlier notes do not break, but the project
%   should prefer char_eq.m as the main interface.

delta = char_eq(lambda, n, epsilon, params);
end
