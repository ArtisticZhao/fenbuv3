function verified_points = refine_and_verify_candidates(candidates, params, opts)
%REFINE_AND_VERIFY_CANDIDATES Run Phase D on all Phase C candidates.

if nargin < 3 || isempty(opts)
    opts = make_phase_d_options();
end

verified_points = struct([]);

for idx = 1:numel(candidates)
    refined = refine_hopf_candidate(candidates(idx), params, opts);
    verified = verify_hopf_point(refined, params, opts);

    if isempty(verified_points)
        verified_points = verified;
    else
        verified_points(end + 1) = verified; %#ok<AGROW>
    end
end
end
