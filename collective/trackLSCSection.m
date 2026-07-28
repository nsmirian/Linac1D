function beam = trackLSCSection(beam, section, constants)
%TRACKLSCSECTION Track a beam through a distributed LSC section.

    arguments
        beam struct
        section struct
        constants struct
    end

    if ~section.enabled
        return;
    end

    if section.nSteps < 1
        error('The number of LSC steps must be positive.');
    end

    ds = section.length / section.nSteps;

    for iStep = 1:section.nSteps

        beam = applyLSCKick(beam, ds, section, constants);

        beam = trackLongitudinalDrift(beam, ds, constants);
    end
end
