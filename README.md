# Linac1D

A one-dimensional MATLAB macroparticle-tracking code for longitudinal
electron-beam dynamics in a linear accelerator.

## Initial capabilities

- Gaussian beam generation
- sinusoidal RF cavity tracking
- first-, second-, and third-order longitudinal transport
- magnetic bunch compression
- current-profile calculation
- bunching-factor calculation
- FFT-based framework for longitudinal space charge

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
