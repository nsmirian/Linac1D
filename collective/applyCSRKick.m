function beam = applyCSRKick(beam, csr, constants)
%APPLYCSRKICK Apply a lumped 1D steady-state CSR energy kick.
%
% This is an approximate compressor CSR model. It applies the CSR kick from
% the final longitudinal beam profile as one lumped kick, rather than
% tracking through individual dipoles with transient entrance and exit
% fields.

    arguments
        beam struct
        csr struct
        constants struct
    end

    if ~csr.enabled
        return;
    end

    nBins = csr.nBins;

    if mod(nBins, 2) ~= 0
        error('For the CSR FFT implementation, nBins must be even.');
    end

    zMean = mean(beam.z);
    sigmaZ = std(beam.z);

    zMin = zMean - 6*sigmaZ;
    zMax = zMean + 6*sigmaZ;

    if zMax <= zMin
        error('The beam has no finite longitudinal extent.');
    end

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

    if isfield(csr, 'smoothing') && csr.smoothing > 0
        current = smoothGaussian(current, csr.smoothing);
    end

    %% Fourier frequencies

    totalLength = nBins * dz;
    modeIndex = [0:(nBins/2-1), -nBins/2:-1].';
    k = 2*pi .* modeIndex ./ totalLength;

    %% Integrated CSR voltage

    currentSpectrum = fft(current);
    Zcsr = csrImpedance(k, csr, constants);
    Zcsr(k == 0) = 0;

    voltageSpectrum = -Zcsr .* currentSpectrum;
    voltageGrid = real(ifft(voltageSpectrum));

    %% Interpolate voltage onto particles

    particleVoltage = interp1( ...
        zGrid, ...
        voltageGrid, ...
        beam.z, ...
        'linear', ...
        0);

    particleEnergy = beam.E0 .* (1 + beam.delta);

    % One volt corresponds numerically to one eV for an electron.
    particleEnergyNew = particleEnergy + particleVoltage;

    beam.delta = ...
        (particleEnergyNew - beam.E0) ./ beam.E0;
end
