function beam = applyLSCKick(beam, ds, section, constants)
%APPLYLSCKICK Apply one longitudinal-space-charge energy kick.
%
% The exact LSC impedance is evaluated in lscImpedance.m.

    arguments
        beam struct
        ds (1,1) double {mustBePositive}
        section struct
        constants struct
    end

    nBins = section.nBins;

    %% Construct a longitudinal grid with some empty space around the bunch

    zMean = mean(beam.z);
    sigmaZ = std(beam.z);

    zMin = zMean - 6*sigmaZ;
    zMax = zMean + 6*sigmaZ;

    edges = linspace(zMin, zMax, nBins + 1);
    dz = edges(2) - edges(1);

    zGrid = 0.5 .* (edges(1:end-1) + edges(2:end));
    zGrid = zGrid(:);

    %% Deposit macroparticle charge

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

    lineCharge = binCharge ./ dz;
    current = constants.c .* lineCharge;

    %% Optional smoothing

    if isfield(section, 'smoothing') && section.smoothing > 0
        current = smoothGaussian(current, section.smoothing);
    end

    %% Fourier frequencies

    totalLength = nBins * dz;

    if mod(nBins, 2) ~= 0
        error('For the current FFT implementation, nBins must be even.');
    end

    modeIndex = [0:(nBins/2-1), -nBins/2:-1].';

    k = 2*pi .* modeIndex ./ totalLength;

    %% Fourier transform of current

    currentSpectrum = fft(current);

    %% LSC impedance per unit length

    ZperLength = lscImpedance(k, beam, section, constants);

    % Suppress the DC component
    ZperLength(k == 0) = 0;

    %% Induced voltage spectrum

    voltageSpectrum = -ZperLength .* currentSpectrum .* ds;

    voltageGrid = real(ifft(voltageSpectrum));

    %% Interpolate voltage onto particles

    particleVoltage = interp1( ...
        zGrid, ...
        voltageGrid, ...
        beam.z, ...
        'linear', ...
        0);

    %% Apply energy kick

    particleEnergy = beam.E0 .* (1 + beam.delta);

    % One volt corresponds numerically to one eV for an electron.
    particleEnergyNew = particleEnergy + particleVoltage;

    beam.delta = ...
        (particleEnergyNew - beam.E0) ./ beam.E0;
end
