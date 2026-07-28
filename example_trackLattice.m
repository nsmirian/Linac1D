clear;
clc;
close all;

projectRoot = fileparts(mfilename('fullpath'));

addpath(fullfile(projectRoot, 'elements'));
addpath(fullfile(projectRoot, 'collective'));
addpath(fullfile(projectRoot, 'diagnostics'));

%% Example: track a beam through a lattice
%
% This script shows how to use trackLattice.m instead of calling each
% element tracking function by hand.

%% Physical constants

constants.c  = 299792458;        % Speed of light [m/s]
constants.e  = 1.602176634e-19;  % Elementary charge [C]
constants.Z0 = 376.730313668;    % Vacuum impedance [Ohm]
constants.me = 0.510998950e6;    % Electron rest energy [eV]

%% Numerical parameters

simulation.nParticles = 2e5;
simulation.nBins      = 1024;

rng(1);

%% Initial beam

beam.E0           = 6.6e6;       % Reference total energy [eV]
beam.charge       = 250e-12;     % Bunch charge [C]
beam.sigma_z      = 1.0e-3;      % Initial rms bunch length [m]
beam.sigma_delta  = 2.0e-4;      % Uncorrelated relative energy spread
beam.sigma_x      = 300e-6;      % Effective rms transverse size [m]
beam.sigma_y      = 300e-6;

beam = generateBeam(beam, simulation.nParticles);

%% Define lattice elements

cavity.type      = 'rfcavity';
cavity.name      = 'Linac 1';
cavity.voltage   = 43.4e6;       % Integrated voltage [V]
cavity.frequency = 1.3e9;        % RF frequency [Hz]
cavity.phase     = deg2rad(-20); % RF phase [rad]
cavity.TTF       = 1.0;          % Transit-time factor

lscSection.type       = 'lscsection';
lscSection.name       = 'LSC section 1';
lscSection.length     = 5.0;     % Section length [m]
lscSection.nSteps     = 100;
lscSection.nBins      = simulation.nBins;
lscSection.pipeRadius = Inf;     % Free-space model initially
lscSection.smoothing  = 2.0;     % Gaussian smoothing in grid cells
lscSection.enabled    = true;   % Keep disabled for this simple example

compressor.type  = 'compressor';
compressor.name  = 'BC1';
compressor.R56   = -0.040;       % [m]
compressor.T566  = 0.0;          % [m]
compressor.U5666 = 0.0;          % [m]

% trackLattice reads this cell array from top to bottom.
lattice = {
    cavity
    lscSection
    compressor
};

%% Track beam

[beamFinal, history] = trackLattice(beam, lattice, constants);

%% Print saved beam states

for iState = 1:numel(history)
    fprintf('\n%s\n', history{iState}.name);
    printBeamParameters(history{iState}.beam, constants);
end

%% Plot phase space at every saved state

for iState = 1:numel(history)
    plotLongitudinalPhaseSpace( ...
        history{iState}.beam, ...
        history{iState}.name);
end

%% Plot current profiles from the saved history

profileBeams = cell(size(history));
profileLabels = cell(size(history));

for iState = 1:numel(history)
    profileBeams{iState} = history{iState}.beam;
    profileLabels{iState} = history{iState}.name;
end

plotLongitudinalBeamProfile( ...
    profileBeams, ...
    profileLabels, ...
    simulation.nBins, ...
    constants, ...
    'trackLattice longitudinal beam profile');

fprintf('\nFinal reference energy = %.6f MeV\n', beamFinal.E0/1e6);
