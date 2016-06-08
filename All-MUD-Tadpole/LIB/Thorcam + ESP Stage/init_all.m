function [ cam, s ] = init_all( )
%
% Initializes the camera and the translation stage
%

    % Initialize the Camera
    cam = init_thorcam();
    
    try
        % Initialize the Translation Stage
        s = serial_init('COM5');
        turn_on_stage(s,1);
    catch errorcode
        %If we get an error, at least close the camera, or everything breaks
        close_thorcam(cam);
        rethrow(errorcode)
    end
end

