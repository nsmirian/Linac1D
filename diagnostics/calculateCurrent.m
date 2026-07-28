function [zGrid, current, lineCharge] = calculateCurrent(beam, nBins, constants)
%CALCULATECURRENT Calculate the longitudinal current profile.
%
% The returned current is positive and represents the magnitude of the
% electron-beam current.

    arguments
        beam struct
        nBins (1,1) double {mustBeInteger, mustBeGreaterThan(nBins, 2)}
        constants struct
    end

    zMin = min(beam.z);
    zMax = max(beam.z);

    if zMax <= zMin
        error('The beam has no finite longitudinal extent.');
    end

    edges = linspace(zMin, zMax, nBins + 1);
    dz = edges(2) - edges(1);

    zGrid = 0.5 .* (edges(1:end-1) + edges(2:end));
    zGrid = zGrid(:);

    particleCharge = beam.charge .* beam.weight;

    [~, ~, binIndex] = histcounts( ...
        beam.z, ...
        edges);

    validParticles = binIndex > 0;

    binCharge = accumarray( ...
        binIndex(validParticles), ...
        particleCharge(validParticles), ...
        [nBins, 1], ...
        @sum, ...
        0);

    lineCharge = binCharge ./ dz;       % [C/m]

    current = constants.c .* lineCharge; % [A]
end
