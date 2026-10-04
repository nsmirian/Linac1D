# AGENTS.md

## Project purpose

This repository contains a one-dimensional longitudinal macroparticle
tracking code for electron linear accelerators.

The code models:

- RF cavities
- longitudinal drifts
- magnetic bunch compressors
- longitudinal space charge
- current profiles
- bunching factors
- microbunching gain

The primary language is MATLAB.

## Coordinate convention

Use:

- z > 0 for particles toward the bunch tail
- delta = (E - E0)/E0
- E0 is the reference total energy in eV
- bunch charge is stored as a positive magnitude

Do not change this convention without updating all maps and tests.

## Units

Use SI units unless explicitly stated:

- position: m
- time: s
- frequency: Hz
- voltage: V
- energy: eV
- charge: C
- current: A
- impedance: Ohm or Ohm/m
- wavenumber: rad/m
- RF phase: rad

## Coding requirements

- Use modular MATLAB functions.
- Add an `arguments` block where appropriate.
- Check dimensions and input validity.
- Avoid global variables.
- Keep physics parameters separate from numerical parameters.
- Document all sign conventions.
- Write tests for every new transport element.
- Do not silently change beam coordinates or normalisation.
- Preserve complex bunching factors and impedance spectra.
- State clearly when a physics model is approximate.

## Validation requirements

Every element must be checked against an analytical limit.

RF cavity:
- compare the fitted chirp with the linear RF expansion
- verify the reference-energy update

Bunch compressor:
- compare numerical compression with
  C = 1/abs(1 + h*R56)

Drift:
- verify the selected R56 sign convention

LSC:
- verify the impedance units
- test zero current
- test uniform current
- test a sinusoidal density modulation
- perform grid, particle-number, and step-size convergence studies

## Current priorities

1. Validate RF cavity and bunch-compressor tracking.
2. Add automated MATLAB tests.
3. Replace the temporary LSC model with a validated round-Gaussian-beam
   free-space impedance.
4. Add controlled sinusoidal density modulation.
5. Calculate microbunching gain.
6. Compare against the existing semi-analytical MBI code.
