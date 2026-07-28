function beam = trackLongitudinalDrift(beam, lengthDrift, constants)
%TRACKLONGITUDINALDRIFT Apply first-order longitudinal dispersion of a drift.

    arguments
        beam struct
        lengthDrift (1,1) double
        constants struct
    end

    gamma = beam.E0 / constants.me;

    R56drift = -lengthDrift / gamma^2;

    beam.z = beam.z + R56drift .* beam.delta;
end
