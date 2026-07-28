function output = smoothGaussian(input, sigmaCells)
%SMOOTHGAUSSIAN Apply Gaussian smoothing to a one-dimensional array.

    arguments
        input (:,1) double
        sigmaCells (1,1) double {mustBeNonnegative}
    end

    if sigmaCells == 0
        output = input;
        return;
    end

    halfWidth = max(3, ceil(4*sigmaCells));
    index = (-halfWidth:halfWidth).';

    kernel = exp(-0.5 .* (index ./ sigmaCells).^2);
    kernel = kernel ./ sum(kernel);

    output = conv(input, kernel, 'same');
end
