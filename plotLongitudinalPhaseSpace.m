function plotLongitudinalPhaseSpace(beam, plotTitle)
%PLOTLONGITUDINALPHASESPACE Plot longitudinal phase space.

    arguments
        beam struct
        plotTitle char = 'Longitudinal phase space'
    end

    nParticles = numel(beam.z);

    % Plot a subset for speed when the beam contains many particles
    nPlot = min(nParticles, 3e4);
    indices = round(linspace(1, nParticles, nPlot));

    figure;

    scatter( ...
        beam.z(indices)*1e3, ...
        beam.delta(indices)*1e3, ...
        4, ...
        'filled');

    xlabel('z [mm]');
    ylabel('\delta [10^{-3}]');
    title(plotTitle);

    grid on;
    box on;
end
