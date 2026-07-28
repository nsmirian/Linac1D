function Zcsr = csrImpedance(k, csr, constants)
%CSRIMPEDANCE Free-space steady-state 1D CSR impedance.
%
% Approximate model:
%   - ultrarelativistic 1D line-charge beam
%   - steady-state CSR in a bend
%   - free space, no shielding
%   - no transient entrance or exit wake
%
% The returned impedance is integrated over csr.length and has units of Ohm.
% The wavenumber k is in rad/m.

    arguments
        k (:,1) double
        csr struct
        constants struct
    end

    if csr.length <= 0
        error('CSR length must be positive.');
    end

    if csr.radius <= 0
        error('CSR bending radius must be positive.');
    end

    Zcsr = complex(zeros(size(k)));

    nonzero = k ~= 0;

    coefficient = ...
        (sqrt(3) + 1i) .* constants.Z0 .* csr.length .* gamma(2/3) ./ ...
        (4 .* 3^(1/3) .* pi);

    Zpositive = coefficient .* ...
        (abs(k(nonzero)) ./ csr.radius.^2).^(1/3);

    Zcsr(nonzero) = Zpositive;

    negative = k < 0;
    Zcsr(negative) = conj(Zcsr(negative));
end
