clear;
clc;

projectRoot = fileparts(fileparts(mfilename('fullpath')));

addpath(fullfile(projectRoot, 'collective'));

constants.Z0 = 376.730313668;    % Vacuum impedance [Ohm]

csr.enabled = true;
csr.length  = 4.0;               % [m]
csr.radius  = 5.0;               % [m]

k = [-20; -10; 0; 10; 20];       % [rad/m]

Zcsr = csrImpedance(k, csr, constants);

assert(Zcsr(k == 0) == 0, 'The DC CSR impedance must be zero.');

assert( ...
    max(abs(Zcsr(k < 0) - conj(flipud(Zcsr(k > 0))))) < 1e-12, ...
    'CSR impedance must satisfy Z(-k) = conj(Z(k)).');

assert( ...
    abs(Zcsr(k == 20) / Zcsr(k == 10) - 2^(1/3)) < 1e-12, ...
    'Free-space steady-state CSR impedance must scale as k^(1/3).');

fprintf('CSR impedance tests passed.\n');
