function bunching = calculateBunching(beam, k)
%CALCULATEBUNCHING Calculate the complex bunching factor.
%
% k may be a scalar or a vector [rad/m].
%
% b(k) = sum_j w_j exp(-i k z_j) / sum_j w_j

    arguments
        beam struct
        k (:,1) double
    end

    z = beam.z(:);
    weights = beam.weight(:);

    weights = weights ./ sum(weights);

    bunching = zeros(size(k));

    for ik = 1:numel(k)
        bunching(ik) = sum( ...
            weights .* exp(-1i .* k(ik) .* z));
    end
end

