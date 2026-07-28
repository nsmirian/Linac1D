function parameters = printBeamParameters(beam, constants)
%PRINTBEAMPARAMETERS Calculate and print basic longitudinal parameters.

    arguments
        beam struct
        constants struct
    end

    zMean = mean(beam.z);
    deltaMean = mean(beam.delta);

    sigmaZ = std(beam.z);
    sigmaDelta = std(beam.delta);

    covarianceMatrix = cov(beam.z, beam.delta);

    if size(covarianceMatrix, 1) == 2 && covarianceMatrix(1,1) > 0
        chirp = covarianceMatrix(1,2) / covarianceMatrix(1,1);
    else
        chirp = NaN;
    end

    gamma = beam.E0 / constants.me;

    parameters.meanZ       = zMean;
    parameters.sigmaZ      = sigmaZ;
    parameters.meanDelta   = deltaMean;
    parameters.sigmaDelta  = sigmaDelta;
    parameters.chirp       = chirp;
    parameters.energy      = beam.E0;
    parameters.gamma       = gamma;

    fprintf('Reference energy       = %.6f MeV\n', beam.E0/1e6);
    fprintf('Relativistic gamma     = %.6f\n', gamma);
    fprintf('Mean z                 = %.6e m\n', zMean);
    fprintf('RMS bunch length       = %.6e m\n', sigmaZ);
    fprintf('RMS bunch duration     = %.6f ps\n', ...
        sigmaZ/constants.c*1e12);
    fprintf('Mean delta             = %.6e\n', deltaMean);
    fprintf('RMS delta              = %.6e\n', sigmaDelta);
    fprintf('Linear chirp h         = %.6e 1/m\n', chirp);
end
