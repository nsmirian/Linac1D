function beam = trackCompressor(beam, compressor)
%TRACKCOMPRESSOR Apply a longitudinal transport map.
%
% z_f = z_i + R56*delta + 1/2*T566*delta^2
%             + 1/6*U5666*delta^3
%
% delta_f = delta_i

    arguments
        beam struct
        compressor struct
    end

    delta = beam.delta;

    beam.z = beam.z ...
        + compressor.R56 .* delta ...
        + 0.5 .* compressor.T566 .* delta.^2 ...
        + (1/6) .* compressor.U5666 .* delta.^3;
end
