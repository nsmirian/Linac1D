function beam = trackCompressor(beam, compressor, constants)
%TRACKCOMPRESSOR Apply a longitudinal transport map.
%
% z_f = z_i + R56*delta + 1/2*T566*delta^2
%             + 1/6*U5666*delta^3
%
% Without CSR, delta_f = delta_i.
%
% If compressor.csr.enabled is true, an approximate lumped 1D free-space
% steady-state CSR kick is applied after the longitudinal map.

    arguments
        beam struct
        compressor struct
        constants struct = struct()
    end

    delta = beam.delta;

    beam.z = beam.z ...
        + compressor.R56 .* delta ...
        + 0.5 .* compressor.T566 .* delta.^2 ...
        + (1/6) .* compressor.U5666 .* delta.^3;

    if isfield(compressor, 'csr') && compressor.csr.enabled
        if isempty(fieldnames(constants))
            error('Constants are required when compressor CSR is enabled.');
        end

        beam = applyCSRKick(beam, compressor.csr, constants);
    end
end
