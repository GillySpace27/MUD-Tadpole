function [ stageStartP stageEndP ] = find_pulse_bounds( cam, s )
%FIND_PULSE_BOUNDS
%   Runs the camera and waits for you to translate the stage manually to
%   each side of the unknown pulse, then press 's'. Exports the bounds.

    fprintf('Find one side of the pulse and press S\n')
    figure();
    movegui('northeast');
    vidcap_thorcam(cam);
    movegui('northwest');
    stageEndP = find_position(s,1);
    
    fprintf('Find the other side of the pulse and press S\n')
    figure();
    movegui('northeast');
    vidcap_thorcam(cam);
    movegui('northwest');
    stageStartP = find_position(s,1);

end

