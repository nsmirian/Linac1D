function plotLongitudinalBeamProfile(beams, labels, nBins, constants, plotTitle)
%PLOTLONGITUDINALBEAMPROFILE Plot longitudinal current profiles.
%
% The current is plotted as a positive magnitude. The coordinate convention
% is z > 0 toward the bunch tail.

    arguments
        beams cell
        labels cell
        nBins (1,1) double {mustBeInteger, mustBeGreaterThan(nBins, 2)}
        constants struct
        plotTitle char = 'Longitudinal beam profile'
    end

    if numel(beams) ~= numel(labels)
        error('The number of beams must match the number of labels.');
    end

    if ~all(cellfun(@(label) ischar(label) || isstring(label), labels))
        error('Labels must be a cell array of character vectors or strings.');
    end

    figure;
    hold on;

    for iBeam = 1:numel(beams)
        beam = beams{iBeam};

        [zGrid, current] = calculateCurrent(beam, nBins, constants);

        plot( ...
            zGrid .* 1e3, ...
            current, ...
            'LineWidth', ...
            1.5);
    end

    xlabel('z [mm]');
    ylabel('Current [A]');
    title(plotTitle);
    legend(labels, 'Location', 'best');

    grid on;
    box on;
end
