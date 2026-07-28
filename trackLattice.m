function [beam, history] = trackLattice(beam, lattice, constants)
%TRACKLATTICE Track the beam through a cell array of elements.

    arguments
        beam struct
        lattice cell
        constants struct
    end

    nElements = numel(lattice);
    history = cell(nElements + 1, 1);

    history{1}.name = 'Initial beam';
    history{1}.beam = beam;

    for iElement = 1:nElements

        element = lattice{iElement};

        switch lower(element.type)

            case 'rfcavity'
                beam = trackRFCavity(beam, element, constants);

            case 'compressor'
                beam = trackCompressor(beam, element, constants);

            case 'lscsection'
                beam = trackLSCSection(beam, element, constants);

            case 'drift'
                beam = trackLongitudinalDrift( ...
                    beam, element.length, constants);

            otherwise
                error( ...
                    'Unknown element type: %s', ...
                    element.type);
        end

        history{iElement + 1}.name = element.name;
        history{iElement + 1}.beam = beam;
    end
end
