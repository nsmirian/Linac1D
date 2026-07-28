function beam = generateBeam(beam, nParticles)
%GENERATEBEAM Generate a Gaussian longitudinal macroparticle distribution.
%
% Convention:
%   z > 0     : particles toward the bunch tail
%   delta > 0 : energy above the reference energy

    arguments
        beam struct
        nParticles (1,1) double {mustBeInteger, mustBePositive}
    end

    beam.z = beam.sigma_z .* randn(nParticles, 1);

    beam.delta = beam.sigma_delta .* randn(nParticles, 1);

    beam.weight = ones(nParticles, 1) ./ nParticles;
end
