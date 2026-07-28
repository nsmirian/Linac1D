function ZperLength = lscImpedance(k, beam, section, constants)
%LSCIMPEDANCE Longitudinal-space-charge impedance per unit length.
%
% This file currently defines the interface only.
%
% It must return:
%
%   ZperLength(k) in Ohm/m
%
% The exact expression depends on:
%   - transverse beam distribution,
%   - beam radius definition,
%   - free space or conducting chamber,
%   - low-k treatment,
%   - Fourier-transform convention.

    arguments
        k (:,1) double
        beam struct
        section struct
        constants struct
    end

    gamma = beam.E0 / constants.me;

    sigmaR = sqrt(beam.sigma_x * beam.sigma_y);

    ZperLength = zeros(size(k));

    nonzero = abs(k) > 0;

    % Temporary long-wavelength inductive approximation.
    %
    % This is useful only for testing the numerical tracking framework.
    % It should not yet be used for quantitative physics conclusions.

    geometricFactor = 1.0;

    ZperLength(nonzero) = ...
        1i .* constants.Z0 .* k(nonzero) ...
        .* geometricFactor ...
        ./ (2*pi*gamma^2);

    % sigmaR is retained because the validated model will depend on it.
    if sigmaR <= 0
        error('The effective transverse beam size must be positive.');
    end

    if isfield(section, 'pipeRadius')
        % Reserved for the conducting-pipe model.
    end
end
