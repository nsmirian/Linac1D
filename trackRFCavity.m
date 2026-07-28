function beam = trackRFCavity(beam, cavity, constants)
%TRACKRFCAVITY Track particles through a thin-lens RF cavity.
%
% Particle energy gain:
%
%   Delta E(z) = V T cos(phi + k_RF z)
%
% Energies are expressed in eV. Therefore, an integrated cavity voltage
% expressed in volts gives the same numerical energy gain in eV for one
% electron.

    arguments
        beam struct
        cavity struct
        constants struct
    end

    kRF = 2*pi*cavity.frequency/constants.c;

    % Individual particle energies before the cavity
    Eparticle = beam.E0 .* (1 + beam.delta);

    % Energy gain of each particle
    dEparticle = cavity.voltage .* cavity.TTF .* ...
        cos(cavity.phase + kRF .* beam.z);

    % Energy gain of the reference particle at z = 0
    dEreference = cavity.voltage .* cavity.TTF .* ...
        cos(cavity.phase);

    % Updated energies
    EparticleNew = Eparticle + dEparticle;
    EreferenceNew = beam.E0 + dEreference;

    if EreferenceNew <= constants.me
        error('Reference energy after RF cavity is not physical.');
    end

    beam.delta = ...
        (EparticleNew - EreferenceNew) ./ EreferenceNew;

    beam.E0 = EreferenceNew;
end
