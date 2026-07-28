clear;
clc;
close all;

addpath('elements');
addpath('collective');
addpath('diagnostics');

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

%% Save initial beam

beamInitial = beam;

%% RF cavity

cavity.name      = 'Linac 1';
cavity.voltage   = 43.4e6;              % Integrated voltage [V]
cavity.frequency = 1.3e9;               % RF frequency [Hz]
cavity.phase     = deg2rad(-20);         % RF phase [rad]
cavity.TTF       = 1.0;                  % Transit-time factor

beam = trackRFCavity(beam, cavity, constants);

beamAfterRF = beam;

%% First LSC section

lscSection.name       = 'LSC section 1';
lscSection.length     = 5.0;             % Section length [m]
lscSection.nSteps     = 50;
lscSection.nBins      = simulation.nBins;
lscSection.pipeRadius = Inf;             % Free-space model initially
lscSection.smoothing  = 2.0;             % Gaussian smoothing in grid cells
lscSection.enabled    = false;

beam = trackLSCSection(beam, lscSection, constants);

beamBeforeBC = beam;

%% Bunch compressor

compressor.name  = 'BC1';
compressor.R56   = -0.040;                % [m]
compressor.T566  = 0.0;                   % [m]
compressor.U5666 = 0.0;                   % [m]

beam = trackCompressor(beam, compressor);

beamAfterBC = beam;

%% Diagnostics

fprintf('\nInitial beam\n');
printBeamParameters(beamInitial, constants);

fprintf('\nAfter RF cavity\n');
printBeamParameters(beamAfterRF, constants);

fprintf('\nBefore bunch compressor\n');
printBeamParameters(beamBeforeBC, constants);

fprintf('\nAfter bunch compressor\n');
printBeamParameters(beamAfterBC, constants);

%% Plots

plotLongitudinalPhaseSpace(beamInitial, 'Initial beam');
plotLongitudinalPhaseSpace(beamAfterRF, 'After RF cavity');
plotLongitudinalPhaseSpace(beamAfterBC, 'After bunch compressor');

plotLongitudinalBeamProfile( ...
    {beamInitial, beamAfterRF, beamAfterBC}, ...
    {'Initial', 'After RF cavity', 'After bunch compressor'}, ...
    simulation.nBins, ...
    constants, ...
    'Longitudinal beam profile');
