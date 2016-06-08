function [ snapPositions ] = create_snapPositions( cam, s, scanResolution )
% Generates a vector containing each location at which a picture should be
% taken along the translation stage

%Ask the user for the bounds of the pulse.
[stageStartP, stageEndP] = find_pulse_bounds(cam, s);

%Calculate throw
throw = abs(stageEndP - stageStartP);

if throw < scanResolution
    %Take one picture in the middle
    snapPositions = (stageStartP + stageEndP) / 2 ;
else
    %Make a position vector with desired resolution (immune to parity)
    if stageEndP > stageStartP
        snapPositions = stageStartP:scanResolution:stageEndP;
    else
        snapPositions = stageStartP:-scanResolution:stageEndP;
    end
end

end

