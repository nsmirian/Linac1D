# Linac1D

A one-dimensional MATLAB macroparticle-tracking code for longitudinal
electron-beam dynamics in a linear accelerator.

## Author

Author: N. S. Mirian  
Affiliation: ...  
Email: ...

## Initial capabilities

- Gaussian beam generation
- sinusoidal RF cavity tracking
- first-, second-, and third-order longitudinal transport
- magnetic bunch compression
- current-profile calculation
- bunching-factor calculation
- FFT-based framework for longitudinal space charge

## Code layout

- `elements/`: single-particle beamline maps, such as RF cavities,
  drifts, and bunch compressors
- `collective/`: collective-effect models, such as longitudinal space charge
- `diagnostics/`: current profiles, bunching factors, beam summaries, and
  plotting helpers
- `main.m`: main example script
- `example_trackLattice.m`: example showing how to build and track a lattice
- `trackLattice.m`: tracks a beam through a cell array of lattice elements

## Coordinate convention

The longitudinal coordinates are

\[
z = c(t-t_{\mathrm{ref}}),
\qquad
\delta = \frac{E-E_0}{E_0}.
\]

Positive `z` denotes the bunch tail.

## Running the example

From MATLAB:

```matlab
run('main.m')
